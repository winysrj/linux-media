Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:14341 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdFZIz4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 04:55:56 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22864.52230.708596.809030@morden.metzler>
Date: Mon, 26 Jun 2017 10:55:34 +0200
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH 4/9] [media] dvb-frontends/stv0910: Fix signal strength reporting
In-Reply-To: <20170624160301.17710-5-d.scheller.oss@gmail.com>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
        <20170624160301.17710-5-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Daniel Scheller writes:
 > From: Daniel Scheller <d.scheller@gmx.net>
 > 
 > Original code at least has some signed/unsigned issues, resulting in
 > values like 32dBm.

I will look into that.

 > Change signal strength readout to work without asking
 > the attached tuner, and use a lookup table instead of log calc. Values

How can you determine the exact strength without knowing what the tuner did?
At least the stv6111 does its own AGC which has to be added.


 > +struct SLookup padc_lookup[] = {
 > +	{    0,  118000 }, /* PADC=+0dBm  */
 > +	{ -100,  93600  }, /* PADC=-1dBm  */
 > +	{ -200,  74500  }, /* PADC=-2dBm  */
 > +	{ -300,  59100  }, /* PADC=-3dBm  */
 > +	{ -400,  47000  }, /* PADC=-4dBm  */
 > +	{ -500,  37300  }, /* PADC=-5dBm  */
 > +	{ -600,  29650  }, /* PADC=-6dBm  */
 > +	{ -700,  23520  }, /* PADC=-7dBm  */
 > +	{ -900,  14850  }, /* PADC=-9dBm  */
 > +	{ -1100, 9380   }, /* PADC=-11dBm */
 > +	{ -1300, 5910   }, /* PADC=-13dBm */
 > +	{ -1500, 3730   }, /* PADC=-15dBm */
 > +	{ -1700, 2354   }, /* PADC=-17dBm */
 > +	{ -1900, 1485   }, /* PADC=-19dBm */
 > +	{ -2000, 1179   }, /* PADC=-20dBm */
 > +	{ -2100, 1000   }, /* PADC=-21dBm */
 > +};
 ...
 > -	if (bbgain < (s32) *strength)
 > -		*strength -= bbgain;
 > -	else
 > -		*strength = 0;
 > +	padc = TableLookup(padc_lookup, ARRAY_SIZE(padc_lookup), Power) + 352;
 >  


Where does the padc_lookup table come from?
I saw it before in CrazyCat github tree.
Is he or you the original source/author or somebody else?


Regards,
Ralph
