Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:42151 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbeG3Ndn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 09:33:43 -0400
Received: by mail-yb0-f193.google.com with SMTP id c10-v6so4613831ybf.9
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 04:59:04 -0700 (PDT)
Received: from mail-yb0-f182.google.com (mail-yb0-f182.google.com. [209.85.213.182])
        by smtp.gmail.com with ESMTPSA id r69-v6sm4827486ywh.44.2018.07.30.04.59.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Jul 2018 04:59:02 -0700 (PDT)
Received: by mail-yb0-f182.google.com with SMTP id r3-v6so4617691ybo.4
        for <linux-media@vger.kernel.org>; Mon, 30 Jul 2018 04:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com> <20180730113900.hqgoujmyqxxzdtcd@paasikivi.fi.intel.com>
In-Reply-To: <20180730113900.hqgoujmyqxxzdtcd@paasikivi.fi.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 30 Jul 2018 20:58:50 +0900
Message-ID: <CAAFQd5A=+c8n6_Us==PuN2+niVZAJ_L6wOGHDjY81MEHTf0sKA@mail.gmail.com>
Subject: Re: [PATCH v2] media: imx208: Add imx208 camera sensor driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: ping-chung.chen@intel.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 30, 2018 at 8:39 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> Hi Tomasz,
>
> On Mon, Jul 30, 2018 at 07:19:56PM +0900, Tomasz Figa wrote:
> ...
> > > +static int imx208_set_ctrl(struct v4l2_ctrl *ctrl)
> > > +{
> > > +       struct imx208 *imx208 =
> > > +               container_of(ctrl->handler, struct imx208, ctrl_handler);
> > > +       struct i2c_client *client = v4l2_get_subdevdata(&imx208->sd);
> > > +       int ret;
> > > +
> > > +       /*
> > > +        * Applying V4L2 control value only happens
> > > +        * when power is up for streaming
> > > +        */
> > > +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> >
> > This is buggy, because it won't handle the case of runtime PM disabled
> > in kernel config. The check should be
> > (!pm_runtime_get_if_in_use(&client->dev)).
>
> Good find. This seems to be the case for most other sensor drivers that
> make use of the function. I can submit a fix for those as well.
>
> I suppose most people use these with runtime PM enabled as this hasn't been
> spotted previously.

Yeah, I spotted it first with imx258 and it took us few emails to get
to the right code. :)

These drivers probably don't have too many users yet in general, so I
guess this didn't manage to cause any problems yet, but it became a
good example of bug propagation via copy/paste. ;)

Fixing would be appreciated indeed!

Best regards,
Tomasz
