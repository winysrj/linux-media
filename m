Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:30186 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1946607AbdEZBvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 21:51:08 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: RE: [PATCH v4] dw9714: Initial driver for dw9714 VCM
Date: Fri, 26 May 2017 01:51:05 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A595AA0A487@FMSMSX114.amr.corp.intel.com>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <20170511075511.GF3227@valkosipuli.retiisi.org.uk>
In-Reply-To: <20170511075511.GF3227@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > > +               if (ret)
> > > +                       dev_err(dev, "%s I2C failure: %d", __func__,
> > > + ret);
> >
> > I think we should just return an error code here and fail the suspend.
> 
> The result from an error here is that the user would hear an audible click.
> I don't think it's worth failing system suspend. :-)
> 
> But as no action is taken based on the error code, there could be quite a few of
> these messages. How about dev_err_once()? For resume I might use
> dev_err_ratelimited().
> 

Ack (addressed with v5 of this patch)
