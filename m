Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44107 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933440Ab2GFLjC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jul 2012 07:39:02 -0400
Message-ID: <4FF6CE48.3000300@iki.fi>
Date: Fri, 06 Jul 2012 14:38:48 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: media_build and Terratec Cinergy T Black.
References: <1341572070.43713.YahooMailClassic@web29402.mail.ird.yahoo.com>
In-Reply-To: <1341572070.43713.YahooMailClassic@web29402.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/06/2012 01:54 PM, Hin-Tak Leung wrote:
> - $ lsdvb seems to be doing garbage:(fedora 17's)
>
> usb (-1975381336:62 64848224:32767) on PCI Domain:-1965359032 Bus:62 Device:64848416 Function:32767
> 	DEVICE:0 ADAPTER:0 FRONTEND:0 (Realtek RTL2832 (DVB-T))
> 		 FE_OFDM Fmin=174MHz Fmax=862MHz
>
> lsdvb on mercury is only marginally better with the PCI zero's, but the other numbers swapped:
>
> usb (62:-1975379912 32767:-348245472) on PCI Domain:0 Bus:0 Device:0 Function:0
> 	DEVICE:0 ADAPTER:0 FRONTEND:0 (Realtek RTL2832 (DVB-T))
> 		 FE_OFDM Fmin=174MHz Fmax=862MHz

I was aware of that tool but didn't know it lists USB devices too.
Someone should fix it working properly for USB devices.

> - 'scandvb' segfault at the end on its own.

I didn't see that.

> - "scandvb /usr/share/dvb/dvb-t/uk-SandyHeath" (supposedly where I am) got a few "WARNING: >>> tuning failed!!!" and no list.
>
> - 'w_scan -G -c GB'
>    have a few curious
> WARNING: received garbage data: crc = 0xcc93876c; expected crc = 0xb81bb6c4
>
> return a list of 26, with entries like (which seems to be vaguely correct):
>
> BBC ONE;(null):522000:B8C23D0G32M64T8Y0:T:27500:101=2:102,106=eng:0:0:4173:9018:4173:0:100

Both scandvb and w_scan works here, same device used. I suspect your 
signal is just simply too weak for reception. Small antenna coming with 
those DVB sticks is not suitable unless you are living very near 
transmitter. Try to connect it roof antenna. One thing that helps a lot 
is to attach small bundled antenna to outside window.

There is both dvbscan and scandvb in Fedora dvb-apps. It is not clear 
for me why two similar looking tools. Anyhow it is just scandvb which I 
found working one.


> So I just put it in ~/.mplayer:channels.conf
>
> Took me a while to figure out that mplayer wants:
>
> mplayer 'dvb://BBC ONE;(null)'
>
> rather than anything else - curious about the ';(null)' part.
>
> --------
> Playing dvb://BBC ONE;(null).
> dvb_tune Freq: 522000
> ERROR IN SETTING DMX_FILTER 9018 for fd 4: ERRNO: 22ERROR, COULDN'T SET CHANNEL  8: Failed to open dvb://BBC ONE;(null).
> ----------

Typical channels.conf entry looks like that:
MTV3:714000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE:305:561:49

And tuning to that channel using mplayer:
mplayer dvb://MTV3

However, I prefer VLC. Just open channels.conf to VLC and should show 
playlist. Totem does not work anymore. at least stream used here in 
Finland. It went broken when they changed from playbin to playbin2 which 
is really shame as it is default video player for Gnome desktop.


> At this point I am lost :-).

Not big surprise unfortunately :/

Unfortunately desktop integration is currently poor and most users are 
coming from the HTPC.

regards
Antti


-- 
http://palosaari.fi/


