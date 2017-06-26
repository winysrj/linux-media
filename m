Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:26617 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdFZKPB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 06:15:01 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22864.56989.452735.990171@morden.metzler>
Date: Mon, 26 Jun 2017 12:14:53 +0200
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Ralph Metzler <rjkm@metzlerbros.de>,
        Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH 4/9] [media] dvb-frontends/stv0910: Fix signal strength
 reporting
In-Reply-To: <20170626070035.17f131e3@vento.lan>
References: <20170624160301.17710-1-d.scheller.oss@gmail.com>
        <20170624160301.17710-5-d.scheller.oss@gmail.com>
        <22864.52230.708596.809030@morden.metzler>
        <20170626070035.17f131e3@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab writes:
 > Em Mon, 26 Jun 2017 10:55:34 +0200
 > Ralph Metzler <rjkm@metzlerbros.de> escreveu:
 > 
 > > Daniel Scheller writes:
 > >  > From: Daniel Scheller <d.scheller@gmx.net>
 > >  > 
 > >  > Original code at least has some signed/unsigned issues, resulting in
 > >  > values like 32dBm.  
 > > 
 > > I will look into that.
 > > 
 > >  > Change signal strength readout to work without asking
 > >  > the attached tuner, and use a lookup table instead of log calc. Values  
 > > 
 > > How can you determine the exact strength without knowing what the tuner did?
 > > At least the stv6111 does its own AGC which has to be added.
 > 
 > I remember I had to solve this issue on some other driver[1][2][3]. What I
 > did was to get the AGC gain from the tuner using a callback,
 > then I added it to the main gain.
 > 
 > [1] https://www.spinics.net/lists/linux-media/msg101836.html
 > [2] https://www.spinics.net/lists/linux-media/msg101838.html
 > [3] https://www.spinics.net/lists/linux-media/msg101842.html
 > 
 > I don't remember why it was not merged upstream, though. Perhaps because
 > I was in doubt about reporting it as "rf_attenuation" or as "agc gain".
 > 
 > Anyway, with something like that, any demod could check for such
 > callback. If defined, add it to its AGC own gain, in order to get
 > the total AGC gain.

I misused get_rf_strength for this in my versions of stv6111.c/stv0910.c.
But get_rf_attenuation would be exactly what we need.

Daniel now removed the get_rf_strength() call from stv0910.c and ignores
the correction from the tuner. That was what I was commenting on.


Regards,
Ralph
