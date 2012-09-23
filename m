Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2IWVt2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Sep 2012 17:49:28 -0400
Date: Sun, 23 Sep 2012 23:49:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
cc: maramaopercheseimorto@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] ov2640: select sensor register bank before applying
 h/v-flip settings
In-Reply-To: <505F73B5.5050105@googlemail.com>
Message-ID: <Pine.LNX.4.64.1209232342260.31250@axis700.grange>
References: <1348431394-30951-1-git-send-email-fschaefer.oss@googlemail.com>
 <Pine.LNX.4.64.1209232326090.31250@axis700.grange> <505F73B5.5050105@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 23 Sep 2012, Frank Sch�fer wrote:

> Am 24.09.2012 00:33, schrieb Guennadi Liakhovetski:
> > On Sun, 23 Sep 2012, Frank Schäfer wrote:
> >
> >> We currently don't select the register bank in ov2640_s_ctrl, so we can end up
> >> writing to DSP register 0x04 instead of sensor register 0x04.
> >> This happens for example when calling ov2640_s_ctrl after ov2640_s_fmt.
> >>
> >> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >> Cc: stable@kernel.org
> > Ok, if Linus decides to release 3.6 tomorrow, I anyway don't think it'd be 
> > reasonable to try to convince him to pull this hours before the release:-) 
> > So, I'll wait for those other 2 fixes from Peter Senna / coccinelle and 
> > submit a normal fixes pull request some time tomorrow. Just wondering:
> 
> Sure.
> 
> >
> >> ---
> >>  drivers/media/i2c/soc_camera/ov2640.c |    5 +++++
> >>  1 Datei geändert, 5 Zeilen hinzugefügt(+)
> > are we soon going to see this line in all possible languages / alphabets / 
> > logographic systems? ;-)
> 
> I don't know, I see this only in your replies, so it seems to be a
> problem with your mail client ?

Sorry, I don't mean those specific Umlaut characters:-) I mean in general 
- here it's in German, next time we see it in Russian / cyrillic, then in 
Japanese / kanji, then in hebrew... See what I mean? :-) I certainly don't 
have anything against those languages as such, I myself switch between a 
couple of them all the time, but this specific line carries information, 
that should be understood by all on this list, IMHO. But well, maybe we'll 
just get used to it just as well as to "Am ... schrieb ..." etc:-) And I 
certainly realise that you (probably:-)) have nothing to do with this, 
rather git maintainers, anyway, enough rant for a Sunday evening:-)

Thanks
Guennadi

> 
> Regards,
> Frank
> 
> >
> > Thanks
> > Guennadi
> >
> >> diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
> >> index 78ac574..d2d298b 100644
> >> --- a/drivers/media/i2c/soc_camera/ov2640.c
> >> +++ b/drivers/media/i2c/soc_camera/ov2640.c
> >> @@ -684,6 +684,11 @@ static int ov2640_s_ctrl(struct v4l2_ctrl *ctrl)
> >>  		&container_of(ctrl->handler, struct ov2640_priv, hdl)->subdev;
> >>  	struct i2c_client  *client = v4l2_get_subdevdata(sd);
> >>  	u8 val;
> >> +	int ret;
> >> +
> >> +	ret = i2c_smbus_write_byte_data(client, BANK_SEL, BANK_SEL_SENS);
> >> +	if (ret < 0)
> >> +		return ret;
> >>  
> >>  	switch (ctrl->id) {
> >>  	case V4L2_CID_VFLIP:
> >> -- 
> >> 1.7.10.4
> >>
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
