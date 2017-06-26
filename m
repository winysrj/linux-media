Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33055 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdFZPkA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 11:40:00 -0400
Received: by mail-wm0-f65.google.com with SMTP id j85so942776wmj.0
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 08:39:59 -0700 (PDT)
Date: Mon, 26 Jun 2017 17:39:56 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at
Subject: Re: [PATCH 4/9] [media] dvb-frontends/stv0910: Fix signal strength
 reporting
Message-ID: <20170626173956.003e6330@audiostation.wuest.de>
In-Reply-To: <22864.52230.708596.809030@morden.metzler>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
        <20170624160301.17710-5-d.scheller.oss@gmail.com>
        <22864.52230.708596.809030@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 26 Jun 2017 10:55:34 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  > 
>  > Original code at least has some signed/unsigned issues, resulting
>  > in values like 32dBm.  
> 
> I will look into that.
> 
>  > Change signal strength readout to work without asking
>  > the attached tuner, and use a lookup table instead of log calc.
>  > Values  
> 
> How can you determine the exact strength without knowing what the
> tuner did? At least the stv6111 does its own AGC which has to be
> added.

Good to know. Though, from what I gathered, a lot of demod drivers are
made this way, e.g. read out the AGC, do some math and have a signal
strength as result. If there are ways to do this better and/or
accurately, then by all means lets do this :)

Re the 32dBm, this is from a user who reported even four different
values on the same coax cable (as he claimed). A MaxS8 and some
measuring gear reported something around -25dBm. With the stv0910, the
initial port from dddvb to the kernel reported those 32dBm,
"the other driver" (suspect he meant dddvb but he wasn't exact in what
that "other driver" was) did report -9dBm, and this changed variant
reported around -30dBm, which seems plausible wrt the MaxS8 and his
gauge.

>  > +struct SLookup padc_lookup[] = {
>  > +	{    0,  118000 }, /* PADC=+0dBm  */
>  > +	{ -100,  93600  }, /* PADC=-1dBm  */
>  > +	{ -200,  74500  }, /* PADC=-2dBm  */
>  > +	{ -300,  59100  }, /* PADC=-3dBm  */
>  > +	{ -400,  47000  }, /* PADC=-4dBm  */
>  > +	{ -500,  37300  }, /* PADC=-5dBm  */
>  > +	{ -600,  29650  }, /* PADC=-6dBm  */
>  > +	{ -700,  23520  }, /* PADC=-7dBm  */
>  > +	{ -900,  14850  }, /* PADC=-9dBm  */
>  > +	{ -1100, 9380   }, /* PADC=-11dBm */
>  > +	{ -1300, 5910   }, /* PADC=-13dBm */
>  > +	{ -1500, 3730   }, /* PADC=-15dBm */
>  > +	{ -1700, 2354   }, /* PADC=-17dBm */
>  > +	{ -1900, 1485   }, /* PADC=-19dBm */
>  > +	{ -2000, 1179   }, /* PADC=-20dBm */
>  > +	{ -2100, 1000   }, /* PADC=-21dBm */
>  > +};  
>  ...
>  > -	if (bbgain < (s32) *strength)
>  > -		*strength -= bbgain;
>  > -	else
>  > -		*strength = 0;
>  > +	padc = TableLookup(padc_lookup, ARRAY_SIZE(padc_lookup),
>  > Power) + 352; 
> 
> 
> Where does the padc_lookup table come from?
> I saw it before in CrazyCat github tree.
> Is he or you the original source/author or somebody else?

Yes, this is picked from CrazyCat's GIT [1], more precisely, from the
commit at [2], which imports an already modified version of your driver
code, hidden behind the message "STV6120 tuner driver" (stv0910 is part
of that commit). Honestly, no idea if he is the actual author of the
table plus the math.

As initially mentioned, if we can fix this and do it the real proper
way, let's do this and drop this patch, but this needs your help.

Best regards,
Daniel Scheller

[1] https://github.com/crazycat69/linux_media
[2]
https://github.com/crazycat69/linux_media/commit/9099babc397bb8bd9d0e33f39156643487378768
-- 
https://github.com/herrnst
