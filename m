Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:40655 "EHLO
        mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbeEADNy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 23:13:54 -0400
Received: by mail-ua0-f169.google.com with SMTP id g9so6737348uak.7
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 20:13:54 -0700 (PDT)
Received: from mail-ua0-f171.google.com (mail-ua0-f171.google.com. [209.85.217.171])
        by smtp.gmail.com with ESMTPSA id r194-v6sm1666076vke.33.2018.04.30.20.13.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Apr 2018 20:13:52 -0700 (PDT)
Received: by mail-ua0-f171.google.com with SMTP id a3so6748122uad.8
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2018 20:13:52 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
 <1522376100-22098-13-git-send-email-yong.zhi@intel.com> <CAAFQd5CXPk4PN2X3_cFsQgeWc4nnWTXiNVPtzd-Fsr-tBeD6yQ@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D34184D71@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <C193D76D23A22742993887E6D207B54D34184D71@ORSMSX106.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 01 May 2018 03:13:41 +0000
Message-ID: <CAAFQd5BDw+g7nyggoqk6Uf-DF4EpLF1Wm1_Ew0pJxQ=5FoJTDw@mail.gmail.com>
Subject: Re: [PATCH v6 12/12] intel-ipu3: Add imgu top level pci device driver
To: Yong Zhi <yong.zhi@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2018 at 2:22 AM Zhi, Yong <yong.zhi@intel.com> wrote:

> Hi, Tomasz,

> Thanks for the review again.

> > -----Original Message-----
> > From: Tomasz Figa [mailto:tfiga@chromium.org]
> > Sent: Thursday, April 26, 2018 12:15 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
> > <sakari.ailus@linux.intel.com>; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Zheng,
> > Jian Xu <jian.xu.zheng@intel.com>
> > Subject: Re: [PATCH v6 12/12] intel-ipu3: Add imgu top level pci device
> > driver
> >
> > Hi Yong,
> >
> > On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
> > [snip]
> > > +static int imgu_video_nodes_init(struct imgu_device *imgu) {
> > > +       struct v4l2_pix_format_mplane *fmts[IPU3_CSS_QUEUES] = { NULL
};
> > > +       struct v4l2_rect *rects[IPU3_CSS_RECTS] = { NULL };
> > > +       unsigned int i;
> > > +       int r;
> > > +
> > > +       imgu->buf_struct_size = sizeof(struct imgu_buffer);
> > > +
> > > +       for (i = 0; i < IMGU_NODE_NUM; i++) {
> > > +               imgu->nodes[i].name = imgu_node_map[i].name;
> > > +               imgu->nodes[i].output = i < IMGU_QUEUE_FIRST_INPUT;
> > > +               imgu->nodes[i].immutable = false;
> > > +               imgu->nodes[i].enabled = false;
> > > +
> > > +               if (i != IMGU_NODE_PARAMS && i != IMGU_NODE_STAT_3A)
> > > +                       fmts[imgu_node_map[i].css_queue] =
> > > +                               &imgu->nodes[i].vdev_fmt.fmt.pix_mp;
> > > +               atomic_set(&imgu->nodes[i].sequence, 0);
> > > +       }
> > > +
> > > +       /* Master queue is always enabled */
> > > +       imgu->nodes[IMGU_QUEUE_MASTER].immutable = true;
> > > +       imgu->nodes[IMGU_QUEUE_MASTER].enabled = true;
> > > +
> > > +       r = ipu3_v4l2_register(imgu);
> > > +       if (r)
> > > +               return r;
> > > +
> > > +       /* Set initial formats and initialize formats of video nodes
*/
> > > +       rects[IPU3_CSS_RECT_EFFECTIVE] = &imgu->rect.eff;
> > > +       rects[IPU3_CSS_RECT_BDS] = &imgu->rect.bds;
> > > +       ipu3_css_fmt_set(&imgu->css, fmts, rects);
> > > +
> > > +       /* Pre-allocate dummy buffers */
> > > +       r = imgu_dummybufs_preallocate(imgu);
> > > +       if (r) {
> > > +               dev_err(&imgu->pci_dev->dev,
> > > +                       "failed to pre-allocate dummy buffers (%d)",
r);
> > > +               imgu_dummybufs_cleanup(imgu);
> >
> > No need to call ipu3_v4l2_unregister() here?
> >
> > (That's why I keep suggesting use of single return error path with
labels
> > named after the first cleanup step that needs to be done, as it makes it
> > easier to spot such mistakes.)
> >

> Good catch, suggestion taken :)

Thanks.


> Maybe I should move the imgu_dummybufs_preallocate() out from
imgu_video_nodes_init().

Either is fine for me. I don't see any big problem in
imgu_dummybufs_preallocate() being in imgu_video_nodes_init(). It must be
done before exposing video nodes to userspace (video_device_register()0, so
it's probably a good place.

Best regards,
Tomasz
