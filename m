Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ABDC4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 21:17:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90E13205F4
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 21:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbfCEVRq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 16:17:46 -0500
Received: from gofer.mess.org ([88.97.38.141]:42821 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbfCEVRp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 16:17:45 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 0DA9560E4D; Tue,  5 Mar 2019 21:17:44 +0000 (GMT)
Date:   Tue, 5 Mar 2019 21:17:43 +0000
From:   Sean Young <sean@mess.org>
To:     Matthias Schwarzott <zzam@gentoo.org>
Cc:     Kangjie Lu <kjlu@umn.edu>, pakki001@umn.edu,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] media: si2165: fix a missing check of return value
Message-ID: <20190305211743.vi6zksuw2eltusif@gofer.mess.org>
References: <20181221045403.59303-1-kjlu@umn.edu>
 <7a5d505d-692b-f067-51f6-815787cffba3@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a5d505d-692b-f067-51f6-815787cffba3@gentoo.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Dec 21, 2018 at 09:24:46AM +0100, Matthias Schwarzott wrote:
> Am 21.12.18 um 05:54 schrieb Kangjie Lu:
> > si2165_readreg8() may fail. Looking into si2165_readreg8(), we will find
> > that "val_tmp" will be an uninitialized value when regmap_read() fails.
> > "val_tmp" is then assigned to "val". So if si2165_readreg8() fails,
> > "val" will be a random value. Further use will lead to undefined
> > behaviors. The fix checks if si2165_readreg8() fails, and if so, returns
> > its error code upstream.
> > 
> > Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> 
> Reviewed-by: Matthias Schwarzott <zzam@gentoo.org>

Unless it is tested on the actual hardware we can't apply this. This could
introduce regressions.

Sean

> 
> > ---
> >  drivers/media/dvb-frontends/si2165.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
> > index feacd8da421d..d55d8f169dca 100644
> > --- a/drivers/media/dvb-frontends/si2165.c
> > +++ b/drivers/media/dvb-frontends/si2165.c
> > @@ -275,18 +275,20 @@ static u32 si2165_get_fe_clk(struct si2165_state *state)
> >  
> >  static int si2165_wait_init_done(struct si2165_state *state)
> >  {
> > -	int ret = -EINVAL;
> > +	int ret;
> >  	u8 val = 0;
> >  	int i;
> >  
> >  	for (i = 0; i < 3; ++i) {
> > -		si2165_readreg8(state, REG_INIT_DONE, &val);
> > +		ret = si2165_readreg8(state, REG_INIT_DONE, &val);
> > +		if (ret < 0)
> > +			return ret;
> >  		if (val == 0x01)
> >  			return 0;
> >  		usleep_range(1000, 50000);
> >  	}
> >  	dev_err(&state->client->dev, "init_done was not set\n");
> > -	return ret;
> > +	return -EINVAL;
> >  }
> >  
> >  static int si2165_upload_firmware_block(struct si2165_state *state,
> > 
