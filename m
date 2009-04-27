Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:55912 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761367AbZD0UiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 16:38:18 -0400
Subject: Re: [linux-dvb] Infos regarding TERRATEC Cinergy HT PCMCIA
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
In-Reply-To: <49F57989.2010302@shlink.ch>
References: <49F57989.2010302@shlink.ch>
Content-Type: text/plain
Date: Mon, 27 Apr 2009 22:35:39 +0200
Message-Id: <1240864539.3974.6.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wolfgang,

Am Montag, den 27.04.2009, 11:23 +0200 schrieb Wolfgang Friedl:
> Hello,
> 
> has anyone tested this card (TERRATEC Cinergy HT PCMCIA) or found useful 
> links I could follow?
> <http://www.terratec.net/de/produkte/Cinergy_HT_PCMCIA_1599.html>
> 
> <http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_HT_PCMCIA>
> <http://www.linuxtv.org/pipermail/linux-dvb/2006-October/013898.html>
> 
> Googleing around did not bring me further (analogue part should be no 
> problem, with the dvb-t part I am not shure)
> 
> kind regards,
> 

the card was added by Hartmut himself, that is why you don't find much
about it on the lists ;)

With "mercurial" installed "hg export 4835" will show his patch.

Analog and DVB-T is enabled for the cardbus device with PCI subsystem
153b:1172.

Cheers,
Hermann


