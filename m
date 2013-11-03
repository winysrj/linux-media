Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:11326 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3KCKrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 05:47:55 -0500
Received: from morden (ip-5-146-184-27.unitymediagroup.de [5.146.184.27])
	by smtp.strato.de (RZmta 32.11 DYNA|AUTH)
	with (TLSv1.2:DHE-RSA-AES256-SHA256 encrypted) ESMTPSA id R010cepA38AscR
	for <linux-media@vger.kernel.org>; Sun, 3 Nov 2013 11:47:53 +0100 (CET)
Received: from rjkm by morden with local (Exim 4.80)
	(envelope-from <rjkm@morden.metzler>)
	id 1VcvDl-0005bh-0f
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 11:47:53 +0100
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21110.10712.785130.198472@morden.metzler>
Date: Sun, 3 Nov 2013 11:47:52 +0100
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/12] dvb-frontends: Support for DVB-C2 to DVB frontends
In-Reply-To: <20131103072351.5aaed530@samsung.com>
References: <20131103002235.GD7956@parallels.com>
	<20131103002425.GE7956@parallels.com>
	<20131103072351.5aaed530@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab writes:
 > Em Sun, 3 Nov 2013 01:24:25 +0100
 > Maik Broemme <mbroemme@parallels.com> escreveu:
 > 
 > > Added support for DVB-C2 to DVB frontends. It will be required
 > > by cxd2843 and tda18212dd (Digital Devices) frontends.
 > > 
 > > Signed-off-by: Maik Broemme <mbroemme@parallels.com>
 > > ---
 > >  include/uapi/linux/dvb/frontend.h | 1 +
 > >  1 file changed, 1 insertion(+)
 > > 
 > > diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
 > > index c56d77c..98648eb 100644
 > > --- a/include/uapi/linux/dvb/frontend.h
 > > +++ b/include/uapi/linux/dvb/frontend.h
 > > @@ -410,6 +410,7 @@ typedef enum fe_delivery_system {
 > >  	SYS_DVBT2,
 > >  	SYS_TURBO,
 > >  	SYS_DVBC_ANNEX_C,
 > > +	SYS_DVBC2,
 > >  } fe_delivery_system_t;
 > >  
 > >  /* backward compatibility */
 > 
 > Please update also the documentation, at Documentation/DocBook/media/dvb.
 > 
 > Doesn't DVB-C2 provide any newer property? If so, please add it there as
 > well, and at frontend.h.
 > 

I asked about this on linux-media a week or so ago. The main question was
concerning STREAM_ID. I asked if it would be fine to combine PLP and
slice id (each 8 bit) into stream_id or if there should be a separate 
new property. And for which one, PLP or slice id? 
Probably slice id, because stream_id is also used for PLP in T2?
I combined them into stream_id for now (but that was after the 0.9.10 version
of the dddvb package).

There are also many new qam types, etc. but, as I said back then, it was not  
urgent for me to add those because the Sony demod does not allow setting those.
At least it is not documented how to do it.


Regards,
Ralph
