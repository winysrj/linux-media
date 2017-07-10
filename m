Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36282 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754149AbdGJPey (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 11:34:54 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so25690268wrb.3
        for <linux-media@vger.kernel.org>; Mon, 10 Jul 2017 08:34:48 -0700 (PDT)
Date: Mon, 10 Jul 2017 17:34:45 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de
Subject: Re: [PATCH 10/14] [media] ddbridge: remove unreachable code
Message-ID: <20170710173445.7f2d7654@audiostation.wuest.de>
In-Reply-To: <22883.14752.984925.317151@morden.metzler>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
        <20170709194221.10255-11-d.scheller.oss@gmail.com>
        <22883.14752.984925.317151@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 10 Jul 2017 10:24:00 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Daniel Scheller writes:
>  > From: Daniel Scheller <d.scheller@gmx.net>
>  >   
>  > >From smatch:  
>  > 
>  >   drivers/media/pci/ddbridge/ddbridge-core.c:3490 snr_store()
>  > info: ignoring unreachable code.
>  > 
>  > In fact, the function immediately returns zero, so remove it and
>  > update ddb_attrs_snr[] to not reference it anymore.
>  > 
>  > Cc: Ralph Metzler <rjkm@metzlerbros.de>
>  > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
>  > ---
>  >  drivers/media/pci/ddbridge/ddbridge-core.c | 27
>  > ++++----------------------- 1 file changed, 4 insertions(+), 23
>  > deletions(-)
>  > 
>  > diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c
>  > b/drivers/media/pci/ddbridge/ddbridge-core.c index
>  > 8981795b0819..3756b9961fcd 100644 ---
>  > a/drivers/media/pci/ddbridge/ddbridge-core.c +++
>  > b/drivers/media/pci/ddbridge/ddbridge-core.c @@ -3236,25 +3236,6
>  > @@ static ssize_t snr_show(struct device *device, return
>  > sprintf(buf, "%s\n", snr); }
>  >  
>  > -
>  > -static ssize_t snr_store(struct device *device, struct
>  > device_attribute *attr,
>  > -			 const char *buf, size_t count)
>  > -{
>  > -	struct ddb *dev = dev_get_drvdata(device);
>  > -	int num = attr->attr.name[3] - 0x30;
>  > -	u8 snr[34] = { 0x01, 0x00 };
>  > -
>  > -	return 0; /* NOE: remove completely? */
>  > -	if (count > 31)
>  > -		return -EINVAL;
>  > -	if (dev->port[num].type >= DDB_TUNER_XO2)
>  > -		return -EINVAL;
>  > -	memcpy(snr + 2, buf, count);
>  > -	i2c_write(&dev->i2c[num].adap, 0x57, snr, 34);
>  > -	i2c_write(&dev->i2c[num].adap, 0x50, snr, 34);
>  > -	return count;
>  > -}
>  > -
>  >  static ssize_t bsnr_show(struct device *device,
>  >  			 struct device_attribute *attr, char *buf)
>  >  {
>  > @@ -3394,10 +3375,10 @@ static struct device_attribute
>  > ddb_attrs_fan[] = { };
>  >  
>  >  static struct device_attribute ddb_attrs_snr[] = {
>  > -	__ATTR(snr0, 0664, snr_show, snr_store),
>  > -	__ATTR(snr1, 0664, snr_show, snr_store),
>  > -	__ATTR(snr2, 0664, snr_show, snr_store),
>  > -	__ATTR(snr3, 0664, snr_show, snr_store),
>  > +	__ATTR_MRO(snr0, snr_show),
>  > +	__ATTR_MRO(snr1, snr_show),
>  > +	__ATTR_MRO(snr2, snr_show),
>  > +	__ATTR_MRO(snr3, snr_show),
>  >  };
>  >  
>  >  static struct device_attribute ddb_attrs_ctemp[] = {
>  > -- 
>  > 2.13.0  
> 
> 
> snr_store was disabled to prevent people from accidentally
> overwriting serial numbers. Maybe it should be a driver/compile
> option.

Is it really neccessary that users - by accident or not - should
be able to tamper with card serials, even "blocked" by compile-time
defines?

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
