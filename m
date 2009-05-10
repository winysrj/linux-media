Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail43.e.nsc.no ([193.213.115.43]:35387 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbZEKAQz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 May 2009 20:16:55 -0400
Message-ID: <4A06F4AF.7050900@free.fr>
Date: Sun, 10 May 2009 17:37:19 +0200
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Infos regarding TERRATEC Cinergy HT PCMCIA
References: <49F57989.2010302@shlink.ch>
In-Reply-To: <49F57989.2010302@shlink.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
> Hello,
>
> has anyone tested this card (TERRATEC Cinergy HT PCMCIA) or found useful
> links I could follow?
> <http://www.terratec.net/de/produkte/Cinergy_HT_PCMCIA_1599.html>
>
> <http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_HT_PCMCIA>
> <http://www.linuxtv.org/pipermail/linux-dvb/2006-October/013898.html>
>    
This card works since I was able to make it work on Fedora and CLFS 
without any problems. The analogue part works with kdetv and mplayer. 
The dvb-t part works too without problems with kaffeine for instance so 
it should work with the dvb-tools. The only thing that needs a little 
effort is the sound that is not directly send to the sound card. You 
need to use the sox trick explained in the linuxtv wiki.

> Googleing around did not bring me further (analogue part should be no
> problem, with the dvb-t part I am not shure)
>
> kind regards,
>    
Best

Mathieu
