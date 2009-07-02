Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:29626 "EHLO
	ctsmtpout1.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753018AbZGBPsa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Jul 2009 11:48:30 -0400
Received: from Inbox (80.27.35.194) by ctsmtpout1.frontal.correo (7.2.056.6) (authenticated as dcrypt$telefonica.net)
        id 4A420A42001829C6 for linux-media@vger.kernel.org; Thu, 2 Jul 2009 17:42:39 +0200
Message-ID: <4A420A42001829C6@ctsmtpout1.frontal.correo> (added by
	    postmaster@telefonica.net)
MIME-Version: 1.0
content-class: 
From: dCrypt <dcrypt@telefonica.net>
Subject: RE: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
Date: Thu, 2 Jul 2009 17:42:34 +0200
To: <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nobody has answered my question yet, I am still waiting to know how to enable 3010i in linux

----- Mensaje original -----
De: Matt <mattmoran76@gmail.com>
Enviado: jueves, 02 de julio de 2009 17:26
Para: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Asunto: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!

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

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

