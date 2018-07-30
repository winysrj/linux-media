Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:47973 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbeG3NNt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 09:13:49 -0400
Date: Mon, 30 Jul 2018 14:39:01 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: ping-chung.chen@intel.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: Re: [PATCH v2] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180730113900.hqgoujmyqxxzdtcd@paasikivi.fi.intel.com>
References: <1532942799-25289-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5D33wzALT+0KkfXKzKs68cYKy05GbHe_SnLakpfJyry3w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Mon, Jul 30, 2018 at 07:19:56PM +0900, Tomasz Figa wrote:
...
> > +static int imx208_set_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +       struct imx208 *imx208 =
> > +               container_of(ctrl->handler, struct imx208, ctrl_handler);
> > +       struct i2c_client *client = v4l2_get_subdevdata(&imx208->sd);
> > +       int ret;
> > +
> > +       /*
> > +        * Applying V4L2 control value only happens
> > +        * when power is up for streaming
> > +        */
> > +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> 
> This is buggy, because it won't handle the case of runtime PM disabled
> in kernel config. The check should be
> (!pm_runtime_get_if_in_use(&client->dev)).

Good find. This seems to be the case for most other sensor drivers that
make use of the function. I can submit a fix for those as well.

I suppose most people use these with runtime PM enabled as this hasn't been
spotted previously.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
