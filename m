Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail45.e.nsc.no ([193.213.115.45]:41389 "EHLO mail45.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbZEKIyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 04:54:23 -0400
Message-ID: <4A07E799.4070501@free.fr>
Date: Mon, 11 May 2009 10:53:45 +0200
From: Mathieu Taillefumier <mathieu.taillefumier@free.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Infos regarding TERRATEC Cinergy HT PCMCIA
References: <49F57989.2010302@shlink.ch> <4A06F4AF.7050900@free.fr> <4A072DC7.9010002@shlink.ch>
In-Reply-To: <4A072DC7.9010002@shlink.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

> absolutely right, works fine, thank you.
> I am sorry I haven't found the time till now to give short message of
> the status till now (as I use to give when having asked on a list)
>    
it is alright
> DVB-T everything OK (Ubuntu 8.x and Debian testing), analogue works by
> using this PCI-DMA "trick" you mentionend (sox with alsa and a 22050
> audio-rate gave best results) One thing to mention: a few channels come
> only mute.
> <http://www.sasag.ch/angebot/kabelTV.php>  (BR and superRTL, are the ones
> as far as I remember).
> It could be, that using a oss=0 option with saa7134 allows, when
> switching to another, "working" channel, then "v4lctl volume mute off"
> and switching back, can get you around - I had to few time to test
> it/was not important enough; this problem seems to be a known issue, I
> had later found some hits on this.
>    
I am not sure to understand. Do you mean that you have two channels with 
the video but without the sound despite the fact that the sound is not 
mute or is it something else. Personally, I never had this problem but I 
am not using my tvcard very often so...

Best

Mathieu
