Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:34327 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbZGBP0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 11:26:06 -0400
Received: by bwz25 with SMTP id 25so1286458bwz.37
        for <linux-media@vger.kernel.org>; Thu, 02 Jul 2009 08:26:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <004701c9aeef$0d127520$27375f60$@net>
References: <496CB23D.6000606@libertysurf.fr> <496D7204.6030501@rogers.com>
	 <496DB023.3090402@libertysurf.fr>
	 <68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com>
	 <004701c9aeef$0d127520$27375f60$@net>
Date: Thu, 2 Jul 2009 16:26:07 +0100
Message-ID: <68fea9390907020826w404eb64ep93cb30aed66496fe@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
From: Matt <mattmoran76@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Is this thread saying that the Pinnacle 3010i is now supported under
linux? if so does this go for the Pinnacle 7010i too?

Thanks,

Matt

2009/3/27 dCrypt <dcrypt@telefonica.net>:
> Hi,
>
> I also own a pair of Pinnacle 3010ix.
>
> Luca, where should the PCI ID go? I can't believe that adding a new card to
> the supported card list is just that simple. Do you know a web page with
> information about it?.
>
> Thanks
>
> -----Mensaje original-----
> De: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] En
> nombre de Luca Tettamanti
> Enviado el: jueves, 15 de enero de 2009 16:44
> Para: Catimimi
> CC: linux-dvb@linuxtv.org; Linux-media
> Asunto: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
>
> On Wed, Jan 14, 2009 at 10:28 AM, Catimimi <catimimi@libertysurf.fr> wrote:
>> try without the ".ko", i.e. instead, use:
>>
>> modprobe saa716x_hybrid
>>
>> OK, shame on me, it works but nothing happens.
>
> Of course ;-) The PCI ID of the card is not listed. I happen to have
> the same card, you can add the ID to the list but note that the
> frontend is not there yet... so the module will load, will print some
> something... and that's it.
> I have a couple of patches queued and I plan to do some
> experimentation in the weekend though ;)
>
> Luca
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
