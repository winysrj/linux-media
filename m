Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:14718 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdGJIMf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 04:12:35 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22883.14056.31492.847795@morden.metzler>
Date: Mon, 10 Jul 2017 10:12:24 +0200
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de,
        rjkm@metzlerbros.de
Subject: [PATCH 3/4] [media] ddbridge: fix buffer overflow in max_set_input_unlocked()
In-Reply-To: <20170709194246.10334-4-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
        <20170709194246.10334-4-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller writes:
 > From: Daniel Scheller <d.scheller@gmx.net>
 > 
 > Picked up code parts introduced one smatch error:
 > 
 >   drivers/media/pci/ddbridge/ddbridge-maxs8.c:163 max_set_input_unlocked() error: buffer overflow 'dev->link[port->lnr].lnb.voltage' 4 <= 255
 > 
 > Fix this by clamping the .lnb.voltage array access to 0-3 by "& 3"'ing
 > dvb->input.
 > 
 > Cc: Ralph Metzler <rjkm@metzlerbros.de>
 > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
 > ---
 >  drivers/media/pci/ddbridge/ddbridge-maxs8.c | 7 ++++---
 >  1 file changed, 4 insertions(+), 3 deletions(-)
 > 
 > diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.c b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
 > index a9dc5f9754da..10716ee8cf59 100644
 > --- a/drivers/media/pci/ddbridge/ddbridge-maxs8.c
 > +++ b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
 > @@ -187,11 +187,12 @@ static int max_set_input_unlocked(struct dvb_frontend *fe, int in)
 >  		return -EINVAL;
 >  	if (dvb->input != in) {
 >  		u32 bit = (1ULL << input->nr);
 > -		u32 obit = dev->link[port->lnr].lnb.voltage[dvb->input] & bit;
 > +		u32 obit =
 > +			dev->link[port->lnr].lnb.voltage[dvb->input & 3] & bit;
 >  
 > -		dev->link[port->lnr].lnb.voltage[dvb->input] &= ~bit;
 > +		dev->link[port->lnr].lnb.voltage[dvb->input & 3] &= ~bit;
 >  		dvb->input = in;
 > -		dev->link[port->lnr].lnb.voltage[dvb->input] |= obit;
 > +		dev->link[port->lnr].lnb.voltage[dvb->input & 3] |= obit;
 >  	}
 >  	res = dvb->set_input(fe, in);
 >  	return res;
 > -- 
 > 2.13.0

dvb->input cannot become > 3.
If it does, it would be caused by some other error, data corruption, etc.

"& 3" just turns one arbitrarily wrong value into another.
