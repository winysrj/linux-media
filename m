Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37518 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2AIIyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 03:54:46 -0500
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Martin Herrman'" <martin.herrman@gmail.com>,
	<linux-media@vger.kernel.org>
Cc: "Ralph Metzler" <rjkm@metzlerbros.de>, <o.endriss@gmx.de>
References: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>	<01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr> <CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
In-Reply-To: <CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
Subject: RE: [DVB Digital Devices Cine CT V6] status support
Date: Mon, 9 Jan 2012 09:54:41 +0100
Message-ID: <003801ccceac$54b5f750$fe21e5f0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Martin Herrman
> Sent: lundi 9 janvier 2012 09:06
> To: linux-media@vger.kernel.org
> Subject: Re: [DVB Digital Devices Cine CT V6] status support
> 
> 2012/1/8 Sébastien RAILLARD (COEXSI) <sr@coexsi.fr>:
> >
> >> http://shop.digital-
> >> devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/62357162/Categ
> >> ori es/HDTV_Karten_fuer_Mediacenter/Cine_PCIe_Serie/DVBC_T
> >>
> >> But.. is this card supported by the Linux kernel?
> >>
> >
> > The short answer is yes, and as far as I know, it's working fine with
> > DVB-T (I've never tested the DVB-C).
> > For support, you need to compile the drivers from Oliver Endriss as
> > they are not merged in mainstream kernel.
> >
> > Check here (kernel > 2.6.31):
> > http://linuxtv.org/hg/~endriss/media_build_experimental/
> > Or here (kernel < 2.6.36) :
> > http://linuxtv.org/hg/~endriss/ngene-octopus-test/
> 
> Hi Sébastien,
> 
> thanks for your quick and positive reply.
> 
> Anyone here that tested it with DVB-C?
> 
> Are there any plans to merge this in the mainstream kernel?
> 

I think Oliver and Ralph are the best persons for answering these questions.

> Regards,
> 
> Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in the body of a message to majordomo@vger.kernel.org More majordomo
> info at  http://vger.kernel.org/majordomo-info.html

