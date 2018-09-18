Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:37587 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeIRUtQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 16:49:16 -0400
Received: by mail-yb1-f195.google.com with SMTP id g79-v6so971640ybf.4
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 08:16:14 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id x184-v6sm2804479ywx.75.2018.09.18.08.16.12
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 08:16:13 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id g79-v6so971567ybf.4
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 08:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <1522376100-22098-1-git-send-email-yong.zhi@intel.com>
 <1522376100-22098-12-git-send-email-yong.zhi@intel.com> <CAAFQd5DdJddmypcpLswQzwV8jdiS1iPGTO=FUJoz+AmnzOy2cg@mail.gmail.com>
 <C193D76D23A22742993887E6D207B54D3DAFA1A2@ORSMSX103.amr.corp.intel.com>
In-Reply-To: <C193D76D23A22742993887E6D207B54D3DAFA1A2@ORSMSX103.amr.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 19 Sep 2018 00:15:58 +0900
Message-ID: <CAAFQd5DC+kFqWY+fMVrTmRTTxyOCx4mEVa4_sZ4rg7Z9jo4K+g@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] intel-ipu3: Add v4l2 driver based on media framework
To: Yong Zhi <yong.zhi@intel.com>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Vijaykumar, Ramya" <ramya.vijaykumar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+Hans Verkuil

(I think he commented on earlier revisions. Please keep anyone who
commented before on CC when sending further revisions.)

On Mon, Sep 17, 2018 at 5:04 AM Zhi, Yong <yong.zhi@intel.com> wrote:
>
> Hi, Tomasz,
>
> Sorry for the delay in responding to your review.
>
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Tomasz Figa
> > Sent: Monday, July 2, 2018 2:50 AM
> > To: Zhi, Yong <yong.zhi@intel.com>
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>; Sakari Ailus
> > <sakari.ailus@linux.intel.com>; Mani, Rajmohan
> > <rajmohan.mani@intel.com>; Toivonen, Tuukka
> > <tuukka.toivonen@intel.com>; Hu, Jerry W <jerry.w.hu@intel.com>; Zheng,
> > Jian Xu <jian.xu.zheng@intel.com>; Vijaykumar, Ramya
> > <ramya.vijaykumar@intel.com>
> > Subject: Re: [PATCH v6 11/12] intel-ipu3: Add v4l2 driver based on media
> > framework
> >
> > Hi Yong,
> >
> > On Fri, Mar 30, 2018 at 11:15 AM Yong Zhi <yong.zhi@intel.com> wrote:
> > [snip]
> > > +static int ipu3_vidioc_enum_input(struct file *file, void *fh,
> > > +                                 struct v4l2_input *input) {
> > > +       if (input->index > 0)
> > > +               return -EINVAL;
> > > +       strlcpy(input->name, "camera", sizeof(input->name));
> > > +       input->type = V4L2_INPUT_TYPE_CAMERA;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int ipu3_vidioc_g_input(struct file *file, void *fh, unsigned
> > > +int *input) {
> > > +       *input = 0;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int ipu3_vidioc_s_input(struct file *file, void *fh, unsigned
> > > +int input) {
> > > +       return input == 0 ? 0 : -EINVAL; }
> > > +
> > > +static int ipu3_vidioc_enum_output(struct file *file, void *fh,
> > > +                                  struct v4l2_output *output) {
> > > +       if (output->index > 0)
> > > +               return -EINVAL;
> > > +       strlcpy(output->name, "camera", sizeof(output->name));
> > > +       output->type = V4L2_INPUT_TYPE_CAMERA;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int ipu3_vidioc_g_output(struct file *file, void *fh,
> > > +                               unsigned int *output) {
> > > +       *output = 0;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +static int ipu3_vidioc_s_output(struct file *file, void *fh,
> > > +                               unsigned int output) {
> > > +       return output == 0 ? 0 : -EINVAL; }
> >
> > Do we really need to implement the 6 functions above? They don't seem to
> > be doing anything useful.
> >
>
> They are here to pass v4l2-compliance test. I can add a note in next update for their purpose.  We can remove them in the future when defaults callbacks are available for those ops.
>

Strange.

Hans, is it really mandatory to implement dmmy output/input setting if
there is no output/input switching capability?

Best regards,
Tomasz
