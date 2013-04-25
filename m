Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533Ab3DYUgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 16:36:49 -0400
Date: Thu, 25 Apr 2013 17:36:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jon Arne =?UTF-8?B?SsO4cmdlbnNlbg==?= <jonarne@jonarne.no>,
	linux-media@vger.kernel.org, jonjon.arnearne@gmail.com,
	linux-kernel@vger.kernel.org, hverkuil@xs4all.nl,
	elezegarcia@gmail.com, mkrufky@linuxtv.org, bjorn@mork.no
Subject: Re: [RFC V2 1/3] [smi2021] Add gm7113c chip to the saa7115 driver
Message-ID: <20130425173629.07c7f377@redhat.com>
In-Reply-To: <20130425171328.08c79893@redhat.com>
References: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
	<1366917020-18217-2-git-send-email-jonarne@jonarne.no>
	<20130425171328.08c79893@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 25 Apr 2013 17:13:28 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Thu, 25 Apr 2013 21:10:18 +0200
> Jon Arne Jørgensen <jonarne@jonarne.no> escreveu:
> 
> > The somagic device uses the gm7113c chip to digitize analog video,
> > this is a clone of the saa7113 chip.
> > 
> > The gm7113c can't be identified over i2c, so I can't rely on
> > saa7115 autodetection.
> > 
> > Signed-off-by: Jon Arne Jørgensen <jonarne@jonarne.no>
> > ---
> >  drivers/media/i2c/saa7115.c     | 61 ++++++++++++++++++++++++++++++++++-------
> >  include/media/v4l2-chip-ident.h |  3 ++
> >  2 files changed, 54 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
> > index 6b6788c..e93b50a 100644
> > --- a/drivers/media/i2c/saa7115.c
> > +++ b/drivers/media/i2c/saa7115.c
> > @@ -54,7 +54,7 @@
> >  
> >  MODULE_DESCRIPTION("Philips SAA7111/SAA7113/SAA7114/SAA7115/SAA7118 video decoder driver");
> >  MODULE_AUTHOR(  "Maxim Yevtyushkin, Kevin Thayer, Chris Kennedy, "
> > -		"Hans Verkuil, Mauro Carvalho Chehab");
> > +		"Hans Verkuil, Mauro Carvalho Chehab, Jon Arne Jørgensen");
> 
> Hi Jon,
> 
> I was told once by Greg KH that the minimal number of changes to be one
> of the driver's authors is to change a significant amount of the code
> (like 20% or more).
> 
> So, I prefer if you don't change it there.
> 
> >  MODULE_LICENSE("GPL");
> >  
> >  static bool debug;
> > @@ -126,6 +126,7 @@ static int saa711x_has_reg(const int id, const u8 reg)
> >  		return 0;
> >  
> >  	switch (id) {
> > +	case V4L2_IDENT_GM7113C:
> >  	case V4L2_IDENT_SAA7113:
> >  		return reg != 0x14 && (reg < 0x18 || reg > 0x1e) && (reg < 0x20 || reg > 0x3f) &&
> >  		       reg != 0x5d && reg < 0x63;
> > @@ -292,7 +293,7 @@ static const unsigned char saa7115_cfg_reset_scaler[] = {
> >  	0x00, 0x00
> >  };
> >  
> > -/* ============== SAA7715 VIDEO templates =============  */
> > +/* ============== SAA7115 VIDEO templates =============  */
> >  
> >  static const unsigned char saa7115_cfg_60hz_video[] = {
> >  	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
> > @@ -445,7 +446,27 @@ static const unsigned char saa7115_cfg_50hz_video[] = {
> >  	0x00, 0x00
> >  };
> >  
> > -/* ============== SAA7715 VIDEO templates (end) =======  */
> > +/* ============== SAA7115 VIDEO templates (end) =======  */
> > +
> > +/* ============== GM7113C VIDEO templates =============  */
> > +
> > +static const unsigned char gm7113c_cfg_60hz_video[] = {
> > +	R_08_SYNC_CNTL, 0x68,			/* 0xBO: auto detection, 0x68 = NTSC */
> > +	R_0E_CHROMA_CNTL_1, 0x07,		/* video autodetection is on */
> > +
> > +	R_5A_V_OFF_FOR_SLICER, 0x06,		/* standard 60hz value for ITU656 line counting */
> > +	0x00, 0x00
> > +};
> > +
> > +static const unsigned char gm7113c_cfg_50hz_video[] = {
> > +	R_08_SYNC_CNTL, 0x28,			/* 0x28 = PAL */
> > +	R_0E_CHROMA_CNTL_1, 0x07,
> > +
> > +	R_5A_V_OFF_FOR_SLICER, 0x03,		/* standard 50hz value */
> > +	0x00, 0x00
> > +};
> > +
> > +/* ============== GM7113C VIDEO templates (end) =======  */
> >  
> >  static const unsigned char saa7115_cfg_vbi_on[] = {
> >  	R_80_GLOBAL_CNTL_1, 0x00,			/* reset tasks */
> > @@ -927,11 +948,17 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
> >  	// This works for NTSC-M, SECAM-L and the 50Hz PAL variants.
> >  	if (std & V4L2_STD_525_60) {
> >  		v4l2_dbg(1, debug, sd, "decoder set standard 60 Hz\n");
> > -		saa711x_writeregs(sd, saa7115_cfg_60hz_video);
> > +		if (state->ident == V4L2_IDENT_GM7113C)
> > +			saa711x_writeregs(sd, gm7113c_cfg_60hz_video);
> > +		else
> > +			saa711x_writeregs(sd, saa7115_cfg_60hz_video);
> >  		saa711x_set_size(sd, 720, 480);
> >  	} else {
> >  		v4l2_dbg(1, debug, sd, "decoder set standard 50 Hz\n");
> > -		saa711x_writeregs(sd, saa7115_cfg_50hz_video);
> > +		if (state->ident == V4L2_IDENT_GM7113C)
> > +			saa711x_writeregs(sd, gm7113c_cfg_50hz_video);
> > +		else
> > +			saa711x_writeregs(sd, saa7115_cfg_50hz_video);
> >  		saa711x_set_size(sd, 720, 576);
> >  	}
> >  
> > @@ -944,7 +971,8 @@ static void saa711x_set_v4lstd(struct v4l2_subdev *sd, v4l2_std_id std)
> >  	011 NTSC N (3.58MHz)            PAL M (3.58MHz)
> >  	100 reserved                    NTSC-Japan (3.58MHz)
> >  	*/
> > -	if (state->ident <= V4L2_IDENT_SAA7113) {
> > +	if (state->ident <= V4L2_IDENT_SAA7113 ||
> > +	    state->ident == V4L2_IDENT_GM7113C) {
> >  		u8 reg = saa711x_read(sd, R_0E_CHROMA_CNTL_1) & 0x8f;
> >  
> >  		if (std == V4L2_STD_PAL_M) {
> > @@ -1215,7 +1243,8 @@ static int saa711x_s_routing(struct v4l2_subdev *sd,
> >  		input, output);
> >  
> >  	/* saa7111/3 does not have these inputs */
> > -	if (state->ident <= V4L2_IDENT_SAA7113 &&
> > +	if ((state->ident <= V4L2_IDENT_SAA7113 ||
> > +	     state->ident == V4L2_IDENT_GM7113C) &&
> >  	    (input == SAA7115_COMPOSITE4 ||
> >  	     input == SAA7115_COMPOSITE5)) {
> >  		return -EINVAL;
> > @@ -1586,8 +1615,11 @@ static int  i2c_client *client,
> >  
> >  	chip_id = name[5];
> >  
> > +
> >  	/* Check whether this chip is part of the saa711x series */
> > -	if (memcmp(name + 1, "f711", 4)) {
> > +	if (memcmp(id->name + 1, "gm7113c", 7)) {
> > +		chip_id = 'c';
> 
> There are several issues on the above:
> 1) "id" may be NULL on autodetect mode;
> 
> 2) Why are you adding 1 here?
>    It should be, instead id->name
> 
> 3) memcmp returns 0 if matches. So, the test is wrong.
>    So, It should be instead:
> 	if (!memcmp(id->name, "gm7113c", 7)) {
> 
> 4) Also, while that works, it seems a little hackish...
> 
> > +	} else if (memcmp(name + 1, "f711", 4)) {
> >  		v4l_dbg(1, debug, client, "chip found @ 0x%x (ID %s) does not match a known saa711x chip.\n",
> >  			client->addr << 1, name);
> >  		return -ENODEV;
> > @@ -1598,8 +1630,12 @@ static int saa711x_probe(struct i2c_client *client,
> >  		v4l_warn(client, "found saa711%c while %s was expected\n",
> >  			 chip_id, id->name);
> >  	}
> > -	snprintf(client->name, sizeof(client->name), "saa711%c", chip_id);
> > -	v4l_info(client, "saa711%c found (%s) @ 0x%x (%s)\n", chip_id, name,
> > +	if (chip_id == 'c')
> 
> especially by needing to add a weird if here.
> See more below:
> 
> > +		snprintf(client->name, sizeof(client->name), "%s", id->name);
> > +	else
> > +		snprintf(client->name, sizeof(client->name), "saa711%c", chip_id);
> > +
> > +	v4l_info(client, "%s found (%s) @ 0x%x (%s)\n", client->name, name,
> >  		 client->addr << 1, client->adapter->name);
> >  
> >  	state = kzalloc(sizeof(struct saa711x_state), GFP_KERNEL);
> > @@ -1645,6 +1681,9 @@ static int saa711x_probe(struct i2c_client *client,
> >  			state->ident = V4L2_IDENT_SAA7111A;
> >  		}
> >  		break;
> > +	case 'c':
> > +		state->ident = V4L2_IDENT_GM7113C;
> > +		break;
> 
> The better would be to initialize state->ident earlier, together with memcmp.
> 
> Even better: please move the detection code into a separate
> routine that would internally fill state->ident and client->name
> and do what's needed to detect the chip.
> 
> That would be cleaner and will reduce a little bit the complexity
> inside saa711x_probe.
> 
> Something like:
> 
> static int saa711x_detect_chip(struct i2c_client *client,
> 			       struct saa711x_state *state,
> 			       const struct i2c_device_id *id)
> {
> 	int i;
> 	char chip_id, name[16];
> 
> 	/*
> 	 * Check for gm7113c (a saa7113 clone). Currently, there's no
> 	 * known way to autodetect it, so boards that use will need to
> 	 * explicitly fill the id->name field.
> 	 */
> 	if (id && !memcmp(id->name, "gm7113c", 7)) {
> 		state->ident = V4L2_IDENT_GM7113C;
> 		snprintf(client->name, sizeof(client->name), "%s", id->name);
> 		return 0;
> 	}


Btw, not sure if you also googled for it, but there's a datasheet for this chip
at:
	http://www.gotecom.com/up_files/download/64200700.pdf

>From what's there, there are 2 versions of this chip (no, I don't read
chinese, but Google translator also helps with this[1]). 

[1] http://translate.google.com.br/translate?sl=zh-CN&tl=en&u=http%3A%2F%2Fwww.gotecom.com%2Fup_files%2Fdownload%2F64200700.pdf

5.2 I2C bus register details
5.2.1 Address 00H

Table 14 chip version (address 00H)
	Function	Logic value
			ID07  ID07  ID07  ID07  ID07  ID07  ID07  ID07
	Chip Version V1  0     0     0     1     X     X     X     X
		     V2  0     0     1     0     X     X     X     X

So, I think you should do something like:

	chip_ver = 0;
	for (i = 0; i < 4; i++) {
		chip_ver = chip_ver << 1;
 		i2c_smbus_write_byte_data(client, 0, i);
 		chip_ver |= (i2c_smbus_read_byte_data(client, 0) & 0x80) ? 1 : 0;
 	}

and fill client-name with the version also, like:

	snprintf(client->name, sizeof(client->name), "%s-%d", id->name, chip_ver);

As it may be important latter to handle the different versions, and/or
better handle bug reports related to some specific version of this chip.

> 	/* Check for Philips/NXP original chips */
> 	for (i = 0; i < sizeof(name); i++) {
> 		i2c_smbus_write_byte_data(client, 0, i);
> 		name[i] = (i2c_smbus_read_byte_data(client, 0) & 0x0f) + '0';
> 		if (name[i] > '9')
> 			name[i] += 'a' - '9' - 1;
> 	}
> 	name[i] = '\0';
> 
> 	if (memcmp(name + 1, "f711", 4))
> 		return -ENODEV;
> 
> 	chip_id = name[5];
> 
> 	snprintf(client->name, sizeof(client->name), "saa711%c", chip_id);
> 
> 	/*
> 	 * Put here the code that fills state->ident for Philips/NXP chips
> 	 */
> ...
> 
> 	return 0;
> }
> 
> >  	case '3':
> >  		state->ident = V4L2_IDENT_SAA7113;
> >  		break;
> > @@ -1675,6 +1714,7 @@ static int saa711x_probe(struct i2c_client *client,
> >  		saa711x_writeregs(sd, saa7111_init);
> >  		break;
> >  	case V4L2_IDENT_SAA7113:
> > +	case V4L2_IDENT_GM7113C:
> >  		saa711x_writeregs(sd, saa7113_init);
> >  		break;
> >  	default:
> > @@ -1711,6 +1751,7 @@ static const struct i2c_device_id saa711x_id[] = {
> >  	{ "saa7114", 0 },
> >  	{ "saa7115", 0 },
> >  	{ "saa7118", 0 },
> > +	{ "gm7113c", 0 },
> >  	{ }
> >  };
> >  MODULE_DEVICE_TABLE(i2c, saa711x_id);
> > diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> > index 4ee125b..fc13d53 100644
> > --- a/include/media/v4l2-chip-ident.h
> > +++ b/include/media/v4l2-chip-ident.h
> > @@ -51,6 +51,9 @@ enum {
> >  	V4L2_IDENT_SAA7114 = 104,
> >  	V4L2_IDENT_SAA7115 = 105,
> >  	V4L2_IDENT_SAA7118 = 108,
> > +	/* This chip is a chinese clone of the saa7113 chip,
> > +	 * with some minor changes/bugs */
> > +	V4L2_IDENT_GM7113C = 149,
> >  
> >  	/* module saa7127: reserved range 150-199 */
> >  	V4L2_IDENT_SAA7127 = 157,
> 
> 


-- 

Cheers,
Mauro
