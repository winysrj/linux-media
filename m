Return-path: <mchehab@pedra>
Received: from smtp2f.orange.fr ([80.12.242.152]:60927 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab0HXGp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Aug 2010 02:45:58 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f23.orange.fr (SMTP Server) with ESMTP id 686388000048
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 08:45:56 +0200 (CEST)
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2f23.orange.fr (SMTP Server) with ESMTP id 58881800018F
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 08:45:56 +0200 (CEST)
Received: from [192.168.1.3] (AOrleans-552-1-46-139.w90-20.abo.wanadoo.fr [90.20.157.139])
	by mwinf2f23.orange.fr (SMTP Server) with ESMTP id 24FC48000048
	for <linux-media@vger.kernel.org>; Tue, 24 Aug 2010 08:45:56 +0200 (CEST)
Message-ID: <4C736AA3.6090402@wanadoo.fr>
Date: Tue, 24 Aug 2010 08:45:55 +0200
From: tomlohave <tomlohave@wanadoo.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Fwd: Re: patch for lifeview hybrid mini
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>



-------- Message original --------
Sujet: 	Re: patch for lifeview hybrid mini
Date : 	Tue, 24 Aug 2010 08:35:39 +0200
De : 	tomlohave@gmail.com <tomlohave@gmail.com>
Pour : 	hermann pitton <hermann-pitton@arcor.de>, jpnews13@free.fr, 
linux-dvb@linuxtv.org



Le 24/08/2010 01:49, hermann pitton a écrit :
>  Hello Thomas,
>
>
Hi hermann
>  the assumption is good then.
>
>  Latest revisions of the Lifeview cards do switch to radio mode with
>  gpio21 high and let it low for TV. (it was the other way round
>  previously)
>
>  I was just wondering, if it might have radio support at all, since
>  gpio21 is not set in the m$ gpio mask and you say it does not come with
>  radio software.
>
>  The gpio18 and 16 can trigger IRQs and are usually in use on such
>  remotes for the button up/down signal and related IRQ sampling.
>
>  All saa7133/35/31e with tda8275ac and radio IF support use a special
>  7.5MHz ceramic filter, usually a huge well visible part in blue or
>  orange color, but on latest designs they are hard to identify, since
>  they might appear as SMD discrets now too.
>
it's hard to look because the card is covered by a metal plate
and we don't want to break it.
>  The switch to this filter is often related to a an antenna connector RF
>  input switch triggered by the same gpio, but not necessarily. All sort
>  of combinations do exist.
>
>
good news :(
>  Anyway, we demodulate the radio IF from such tuners on the
>  saa7133/35/31e on the saa chip and do also the stereo separation and
>  detection there. Hartmut added the needed code in saa7134-tvaudio and it
>  is valid for all tuner=54.
>
>  To achieve that, you need to use amux = TV for radio and likely also
>  some gpio is involved for the RF routing.
>
>
Will look at this.
Many thanks.
>  Cheers,
>  Hermann
>
>
>
>

Best regards,

thomas



