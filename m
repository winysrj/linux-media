Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35738 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753646AbdGJPnZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:43:25 -0400
Received: by mail-lf0-f65.google.com with SMTP id z78so11157547lff.2
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 08:43:19 -0700 (PDT)
Date: Mon, 10 Jul 2017 17:43:16 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 3/4] [media] ddbridge: fix buffer overflow in
 max_set_input_unlocked()
Message-ID: <20170710174316.1b609219@audiostation.wuest.de>
In-Reply-To: <22883.14056.31492.847795@morden.metzler>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
        <20170709194246.10334-4-d.scheller.oss@gmail.com>
        <22883.14056.31492.847795@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 10 Jul 2017 10:12:24 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  > 
>  > Picked up code parts introduced one smatch error:
>  > 
>  >   drivers/media/pci/ddbridge/ddbridge-maxs8.c:163
>  > max_set_input_unlocked() error: buffer overflow
>  > 'dev->link[port->lnr].lnb.voltage' 4 <= 255
>  > 
>  > Fix this by clamping the .lnb.voltage array access to 0-3 by "&
>  > 3"'ing dvb->input.
>  > 
>  > Cc: Ralph Metzler <rjkm@metzlerbros.de>
>  > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
>  > ---
>  >  drivers/media/pci/ddbridge/ddbridge-maxs8.c | 7 ++++---
>  >  1 file changed, 4 insertions(+), 3 deletions(-)
>  > 
>  > diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.c
>  > b/drivers/media/pci/ddbridge/ddbridge-maxs8.c index
>  > a9dc5f9754da..10716ee8cf59 100644 ---
>  > a/drivers/media/pci/ddbridge/ddbridge-maxs8.c +++
>  > b/drivers/media/pci/ddbridge/ddbridge-maxs8.c @@ -187,11 +187,12
>  > @@ static int max_set_input_unlocked(struct dvb_frontend *fe, int
>  > in) return -EINVAL; if (dvb->input != in) {
>  >  		u32 bit = (1ULL << input->nr);
>  > -		u32 obit =
>  > dev->link[port->lnr].lnb.voltage[dvb->input] & bit;
>  > +		u32 obit =
>  > +
>  > dev->link[port->lnr].lnb.voltage[dvb->input & 3] & bit; 
>  > -		dev->link[port->lnr].lnb.voltage[dvb->input] &=
>  > ~bit;
>  > +		dev->link[port->lnr].lnb.voltage[dvb->input & 3]
>  > &= ~bit; dvb->input = in;
>  > -		dev->link[port->lnr].lnb.voltage[dvb->input] |=
>  > obit;
>  > +		dev->link[port->lnr].lnb.voltage[dvb->input & 3]
>  > |= obit; }
>  >  	res = dvb->set_input(fe, in);
>  >  	return res;
>  > -- 
>  > 2.13.0  
> 
> dvb->input cannot become > 3.

Sure, guess else you'd have received quite some OOPS reports due to
this :-)

Same reason as for the other patch applies - if we don't fix this
warning now then someone else will. OTOH, if Mauro is comfortable with
this, then lets just keep it as it is and drop this (and also the
other) patch.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
