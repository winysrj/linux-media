Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39635
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751464AbdFZKAy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 06:00:54 -0400
Date: Mon, 26 Jun 2017 07:00:35 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH 4/9] [media] dvb-frontends/stv0910: Fix signal strength
 reporting
Message-ID: <20170626070035.17f131e3@vento.lan>
In-Reply-To: <22864.52230.708596.809030@morden.metzler>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
        <20170624160301.17710-5-d.scheller.oss@gmail.com>
        <22864.52230.708596.809030@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Jun 2017 10:55:34 +0200
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  > 
>  > Original code at least has some signed/unsigned issues, resulting in
>  > values like 32dBm.  
> 
> I will look into that.
> 
>  > Change signal strength readout to work without asking
>  > the attached tuner, and use a lookup table instead of log calc. Values  
> 
> How can you determine the exact strength without knowing what the tuner did?
> At least the stv6111 does its own AGC which has to be added.

I remember I had to solve this issue on some other driver[1][2][3]. What I
did was to get the AGC gain from the tuner using a callback,
then I added it to the main gain.

[1] https://www.spinics.net/lists/linux-media/msg101836.html
[2] https://www.spinics.net/lists/linux-media/msg101838.html
[3] https://www.spinics.net/lists/linux-media/msg101842.html

I don't remember why it was not merged upstream, though. Perhaps because
I was in doubt about reporting it as "rf_attenuation" or as "agc gain".

Anyway, with something like that, any demod could check for such
callback. If defined, add it to its AGC own gain, in order to get
the total AGC gain.

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
>  > +	padc = TableLookup(padc_lookup, ARRAY_SIZE(padc_lookup), Power) + 352;
>  >    
> 
> 
> Where does the padc_lookup table come from?
> I saw it before in CrazyCat github tree.
> Is he or you the original source/author or somebody else?
> 
> 
> Regards,
> Ralph



Thanks,
Mauro
