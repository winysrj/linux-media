Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43859 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3KCLWl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 06:22:41 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO007U9Q9RGR30@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 06:22:40 -0500 (EST)
Date: Sun, 03 Nov 2013 09:22:36 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/12] dvb-frontends: Support for DVB-C2 to DVB frontends
Message-id: <20131103092236.34d51192@samsung.com>
In-reply-to: <21110.10712.785130.198472@morden.metzler>
References: <20131103002235.GD7956@parallels.com>
 <20131103002425.GE7956@parallels.com> <20131103072351.5aaed530@samsung.com>
 <21110.10712.785130.198472@morden.metzler>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Nov 2013 11:47:52 +0100
Ralph Metzler <rjkm@metzlerbros.de> escreveu:

> Mauro Carvalho Chehab writes:
>  > Em Sun, 3 Nov 2013 01:24:25 +0100
>  > Maik Broemme <mbroemme@parallels.com> escreveu:
>  > 
>  > > Added support for DVB-C2 to DVB frontends. It will be required
>  > > by cxd2843 and tda18212dd (Digital Devices) frontends.
>  > > 
>  > > Signed-off-by: Maik Broemme <mbroemme@parallels.com>
>  > > ---
>  > >  include/uapi/linux/dvb/frontend.h | 1 +
>  > >  1 file changed, 1 insertion(+)
>  > > 
>  > > diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
>  > > index c56d77c..98648eb 100644
>  > > --- a/include/uapi/linux/dvb/frontend.h
>  > > +++ b/include/uapi/linux/dvb/frontend.h
>  > > @@ -410,6 +410,7 @@ typedef enum fe_delivery_system {
>  > >  	SYS_DVBT2,
>  > >  	SYS_TURBO,
>  > >  	SYS_DVBC_ANNEX_C,
>  > > +	SYS_DVBC2,
>  > >  } fe_delivery_system_t;
>  > >  
>  > >  /* backward compatibility */
>  > 
>  > Please update also the documentation, at Documentation/DocBook/media/dvb.
>  > 
>  > Doesn't DVB-C2 provide any newer property? If so, please add it there as
>  > well, and at frontend.h.
>  > 
> 
> I asked about this on linux-media a week or so ago. 

Oh! Well, several developers were out last week, as we had the media workshop
on Oct, 23. So, we likely missed it.

> The main question was
> concerning STREAM_ID. I asked if it would be fine to combine PLP and
> slice id (each 8 bit) into stream_id or if there should be a separate 
> new property. And for which one, PLP or slice id? 
> Probably slice id, because stream_id is also used for PLP in T2?
> I combined them into stream_id for now (but that was after the 0.9.10 version
> of the dddvb package).
> 
> There are also many new qam types, etc. but, as I said back then, it was not  
> urgent for me to add those because the Sony demod does not allow setting those.
> At least it is not documented how to do it.

Ok, let me answer to that thread, in order to have all the discussions on
a single one.

Regards,
Mauro
-- 

Cheers,
Mauro
