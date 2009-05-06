Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp103.mail.ukl.yahoo.com ([77.238.184.35]:26532 "HELO
	smtp103.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753629AbZEFUiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2009 16:38:50 -0400
Subject: Re: saa7134-alsa and snd_card_new only error with alsa 1.0.19 /
 ubuntu 9.04 jaunty - tracked down, further help appreciated
From: Lars Oliver Hansen <lars.hansen@yahoo.co.uk>
To: linux-media@vger.kernel.org
In-Reply-To: <1241552015.7752.29.camel@lars-laptop>
References: <1241552015.7752.29.camel@lars-laptop>
Content-Type: text/plain
Date: Wed, 06 May 2009 22:38:52 +0200
Message-Id: <1241642332.4042.15.camel@lars-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

Am Dienstag, den 05.05.2009, 21:33 +0200 schrieb Lars Oliver Hansen:
> So I would have instead of a wrapped call to a non-existant snd_card_new
> a direct call to an exported snd_card_create.

me adding snd_card_create to the Ubuntu sources (headers to be precise)
obviously means it wasn't present before and Ubuntus kernel was compiled
with that code missing, thus "no symbol_version" error message then!

I now opted for disabling the call to snd_card_new and letting v4l s
snd_card_create return -NOEMEM or so.

Now I get "saa7134 ALSA driver for DMA sound loaded" message in dmesg
but I have no sound in tvtime and neither aplay -L nor aplay -l list a
tv-card related sound device and I don't find any audio0 or sound0
device in /dev/.

Is NEED_SND_CARD_CREATE needed for my tv card? It was defined and the
~_new couldn't be found on loading the module, but would it have been
used? If not (or if), is there a way to get (still) sound in tvtime (or
mplayer)? My card is AVerMedia Cardbus TV/Radio (E506R) correctly
autodetected (if I can trust packaging and labelling of my card ;-)) :-)
(it's a hybrid dvb-t / analog device. Yes, dvb-t works, but the channel
I'm interested in occasionally has signal troubles (I'm at a triangle
vertex of the covered area)).

Thank you very much!

B&KR

Lars

