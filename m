Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:16930 "EHLO
	ctsmtpout4.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753621AbZC0PR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:17:27 -0400
From: "dCrypt" <dcrypt@telefonica.net>
Cc: <linux-dvb@linuxtv.org>,
	"'Linux-media'" <linux-media@vger.kernel.org>
References: <496CB23D.6000606@libertysurf.fr> <496D7204.6030501@rogers.com>	<496DB023.3090402@libertysurf.fr> <68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com>
In-Reply-To: <68676e00901150743q5576fefane2d2818dc6cd9cb0@mail.gmail.com>
Subject: RE: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!
Date: Fri, 27 Mar 2009 16:16:43 +0100
Message-ID: <004701c9aeef$0d127520$27375f60$@net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: es
To: unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I also own a pair of Pinnacle 3010ix.

Luca, where should the PCI ID go? I can't believe that adding a new card to
the supported card list is just that simple. Do you know a web page with
information about it?.

Thanks

-----Mensaje original-----
De: linux-dvb-bounces@linuxtv.org [mailto:linux-dvb-bounces@linuxtv.org] En
nombre de Luca Tettamanti
Enviado el: jueves, 15 de enero de 2009 16:44
Para: Catimimi
CC: linux-dvb@linuxtv.org; Linux-media
Asunto: Re: [linux-dvb] Pinnacle dual Hybrid pro PCI-express - linuxTV!

On Wed, Jan 14, 2009 at 10:28 AM, Catimimi <catimimi@libertysurf.fr> wrote:
> try without the ".ko", i.e. instead, use:
>
> modprobe saa716x_hybrid
>
> OK, shame on me, it works but nothing happens.

Of course ;-) The PCI ID of the card is not listed. I happen to have
the same card, you can add the ID to the list but note that the
frontend is not there yet... so the module will load, will print some
something... and that's it.
I have a couple of patches queued and I plan to do some
experimentation in the weekend though ;)

Luca

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

