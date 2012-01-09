Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43470 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab2AIIFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 03:05:32 -0500
Received: by wibhm6 with SMTP id hm6so2341527wib.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2012 00:05:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr>
References: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>
	<01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr>
Date: Mon, 9 Jan 2012 09:05:31 +0100
Message-ID: <CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
Subject: Re: [DVB Digital Devices Cine CT V6] status support
From: Martin Herrman <martin.herrman@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/8 Sébastien RAILLARD (COEXSI) <sr@coexsi.fr>:
>
>> http://shop.digital-
>> devices.de/epages/62357162.sf/en_GB/?ObjectPath=/Shops/62357162/Categori
>> es/HDTV_Karten_fuer_Mediacenter/Cine_PCIe_Serie/DVBC_T
>>
>> But.. is this card supported by the Linux kernel?
>>
>
> The short answer is yes, and as far as I know, it's working fine with DVB-T
> (I've never tested the DVB-C).
> For support, you need to compile the drivers from Oliver Endriss as they are
> not merged in mainstream kernel.
>
> Check here (kernel > 2.6.31):
> http://linuxtv.org/hg/~endriss/media_build_experimental/
> Or here (kernel < 2.6.36) :
> http://linuxtv.org/hg/~endriss/ngene-octopus-test/

Hi Sébastien,

thanks for your quick and positive reply.

Anyone here that tested it with DVB-C?

Are there any plans to merge this in the mainstream kernel?

Regards,

Martin
