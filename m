Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2DADC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 17:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF1120685
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 17:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbfAJRA3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 10 Jan 2019 12:00:29 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34168 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727943AbfAJRA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Jan 2019 12:00:28 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 59F70634C7E;
        Thu, 10 Jan 2019 18:59:04 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1ghdfb-0002hH-Ne; Thu, 10 Jan 2019 18:59:03 +0200
Date:   Thu, 10 Jan 2019 18:59:03 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Lubomir Rintel <lkundrak@v3.sk>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH v3 03/14] media: ov7670: hook s_power onto v4l2 core
Message-ID: <20190110165903.gcedksczp5tmkl5t@valkosipuli.retiisi.org.uk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
 <20181120100318.367987-4-lkundrak@v3.sk>
 <20181122122146.a6wydozsg676i3w7@valkosipuli.retiisi.org.uk>
 <868bd721260bc8948835fe2a697a047ae2277cd0.camel@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868bd721260bc8948835fe2a697a047ae2277cd0.camel@v3.sk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Lubomir,

On Wed, Nov 28, 2018 at 12:29:33PM +0100, Lubomir Rintel wrote:
> On Thu, 2018-11-22 at 14:21 +0200, Sakari Ailus wrote:
> > Hi Lubomir,
> > 
> > On Tue, Nov 20, 2018 at 11:03:08AM +0100, Lubomir Rintel wrote:
> > > The commit 71862f63f351 ("media: ov7670: Add the ov7670_s_power function")
> > > added a power control routing. However, it was not good enough to use as
> > > a s_power() callback: it merely flipped on the power GPIOs without
> > > restoring the register settings.
> > > 
> > > Fix this now and register an actual power callback.
> > > 
> > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > 
> > > ---
> > > Changes since v2:
> > > - Restore the controls, format and frame rate on power on
> > > 
> > >  drivers/media/i2c/ov7670.c | 50 +++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 44 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > > index ead0c360df33..cbaab60aaaac 100644
> > > --- a/drivers/media/i2c/ov7670.c
> > > +++ b/drivers/media/i2c/ov7670.c
...
> > > @@ -1945,7 +1983,7 @@ static int ov7670_remove(struct i2c_client *client)
> > >  	v4l2_ctrl_handler_free(&info->hdl);
> > >  	clk_disable_unprepare(info->clk);
> > >  	media_entity_cleanup(&info->sd.entity);
> > > -	ov7670_s_power(sd, 0);
> > > +	ov7670_power_off(sd);
> > >  	return 0;
> > >  }
> > >  
> > 
> > Could you consider instead switching to runtime PM? A few drivers such as
> > the ov2685 driver does that already.
> 
> Yes, I'll take a look. Thanks for the suggestion. I didn't know such
> thing exists, so it may take some time for me to grasp it though.

I'm be tempted to merge the ov7670 patches as they significantly improve
the driver, even if we're at the moment missing the runtime PM conversion.
It could be done later on as well.

Would that be ok for you?

-- 
Kind regards,

Sakari Ailus
