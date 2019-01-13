Return-Path: <SRS0=qapk=PV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D03C43387
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 16:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E045206B6
	for <linux-media@archiver.kernel.org>; Sun, 13 Jan 2019 16:39:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfAMQjF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 13 Jan 2019 11:39:05 -0500
Received: from shell.v3.sk ([90.176.6.54]:43015 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfAMQjF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 Jan 2019 11:39:05 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 9825342050;
        Sun, 13 Jan 2019 17:39:00 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ynyLaERhYmOi; Sun, 13 Jan 2019 17:38:57 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 92BB1427FF;
        Sun, 13 Jan 2019 17:38:57 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vlvH9nR9M4pw; Sun, 13 Jan 2019 17:38:57 +0100 (CET)
Received: from nedofet.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 7E0D542050;
        Sun, 13 Jan 2019 17:38:56 +0100 (CET)
Message-ID: <0f9b127c407cebb390ca0a4f5d923e7aef1359c9.camel@v3.sk>
Subject: Re: [PATCH v3 03/14] media: ov7670: hook s_power onto v4l2 core
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Date:   Sun, 13 Jan 2019 17:38:55 +0100
In-Reply-To: <20190110165903.gcedksczp5tmkl5t@valkosipuli.retiisi.org.uk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
         <20181120100318.367987-4-lkundrak@v3.sk>
         <20181122122146.a6wydozsg676i3w7@valkosipuli.retiisi.org.uk>
         <868bd721260bc8948835fe2a697a047ae2277cd0.camel@v3.sk>
         <20190110165903.gcedksczp5tmkl5t@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-01-10 at 18:59 +0200, Sakari Ailus wrote:
> Hi Lubomir,
> 
> On Wed, Nov 28, 2018 at 12:29:33PM +0100, Lubomir Rintel wrote:
> > On Thu, 2018-11-22 at 14:21 +0200, Sakari Ailus wrote:
> > > Hi Lubomir,
> > > 
> > > On Tue, Nov 20, 2018 at 11:03:08AM +0100, Lubomir Rintel wrote:
> > > > The commit 71862f63f351 ("media: ov7670: Add the ov7670_s_power function")
> > > > added a power control routing. However, it was not good enough to use as
> > > > a s_power() callback: it merely flipped on the power GPIOs without
> > > > restoring the register settings.
> > > > 
> > > > Fix this now and register an actual power callback.
> > > > 
> > > > Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> > > > 
> > > > ---
> > > > Changes since v2:
> > > > - Restore the controls, format and frame rate on power on
> > > > 
> > > >  drivers/media/i2c/ov7670.c | 50 +++++++++++++++++++++++++++++++++-----
> > > >  1 file changed, 44 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> > > > index ead0c360df33..cbaab60aaaac 100644
> > > > --- a/drivers/media/i2c/ov7670.c
> > > > +++ b/drivers/media/i2c/ov7670.c
> ...
> > > > @@ -1945,7 +1983,7 @@ static int ov7670_remove(struct i2c_client *client)
> > > >  	v4l2_ctrl_handler_free(&info->hdl);
> > > >  	clk_disable_unprepare(info->clk);
> > > >  	media_entity_cleanup(&info->sd.entity);
> > > > -	ov7670_s_power(sd, 0);
> > > > +	ov7670_power_off(sd);
> > > >  	return 0;
> > > >  }
> > > >  
> > > 
> > > Could you consider instead switching to runtime PM? A few drivers such as
> > > the ov2685 driver does that already.
> > 
> > Yes, I'll take a look. Thanks for the suggestion. I didn't know such
> > thing exists, so it may take some time for me to grasp it though.
> 
> I'm be tempted to merge the ov7670 patches as they significantly improve
> the driver, even if we're at the moment missing the runtime PM conversion.
> It could be done later on as well.
> 
> Would that be ok for you?

Yes, I'm fine with it. In fact, I'm happy about it.

I'd eventually like to implement the runtime PM, but it's not going to
happen before 5.1 merge window.

Cheers
Lubo

