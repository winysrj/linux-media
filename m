Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:46207 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbeGaFjm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 01:39:42 -0400
Received: by mail-yb0-f196.google.com with SMTP id c3-v6so5632948ybi.13
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 21:01:30 -0700 (PDT)
Received: from mail-yb0-f176.google.com (mail-yb0-f176.google.com. [209.85.213.176])
        by smtp.gmail.com with ESMTPSA id v185-v6sm6160500ywc.94.2018.07.30.21.01.28
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jul 2018 21:01:29 -0700 (PDT)
Received: by mail-yb0-f176.google.com with SMTP id s1-v6so5641590ybk.3
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 21:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com> <5E40A82D0551C84FA2888225EDABBE093FAA3EE3@PGSMSX105.gar.corp.intel.com>
In-Reply-To: <5E40A82D0551C84FA2888225EDABBE093FAA3EE3@PGSMSX105.gar.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 31 Jul 2018 13:01:17 +0900
Message-ID: <CAAFQd5DCrT=uUJ02LDzruEK_Cjf0DiT5tdFhxeNNYub--Fr4XQ@mail.gmail.com>
Subject: Re: [PATCH v2] media: imx208: Add imx208 camera sensor driver
To: ping-chung.chen@intel.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2018 at 12:54 PM Chen, Ping-chung
<ping-chung.chen@intel.com> wrote:
>
> Hi Tomasz,
>
> >-----Original Message-----
> > +/* Get bayer order based on flip setting. */ static __u32
> > +imx208_get_format_code(struct imx208 *imx208)
>
> >Why not just "u32"?
>
> Its return value will be assigned to the variable code which belongs to the structure
> v4l2_subdev_mbus_code_enum, and the type of this variable is __u32.
> struct v4l2_subdev_mbus_code_enum {
>         __u32 pad;
>         __u32 index;
>         __u32 code;
>         __u32 which;
>         __u32 reserved[8];
> };
>
> > +{
> > +       /*
> > +        * Only one bayer order is supported.
> > +        * It depends on the flip settings.
> > +        */
> > +       static const __u32 codes[2][2] = {
>
> >Ditto.
>
> > +               { MEDIA_BUS_FMT_SRGGB10_1X10, MEDIA_BUS_FMT_SGRBG10_1X10, },
> > +               { MEDIA_BUS_FMT_SGBRG10_1X10, MEDIA_BUS_FMT_SBGGR10_1X10, },
> > +       };
> > +
> > +       return codes[imx208->vflip->val][imx208->hflip->val];
> > +}
> > +

That's okay. __u32 is an equivalent of u32 defined to be used in UAPI
headers. Inside of kernel-only code, u32 should be used.

Best regards,
Tomasz
