Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp125.rog.mail.re2.yahoo.com ([206.190.53.30]:25092 "HELO
	smtp125.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751023AbZBVVRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 16:17:06 -0500
Message-ID: <49A1C0D0.10905@rogers.com>
Date: Sun, 22 Feb 2009 16:17:04 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Riba_Zolt=E1n?= <libus@madmac.hu>
CC: V4L <video4linux-list@redhat.com>,
	Linux-media <linux-media@vger.kernel.org>
Subject: Re: Newbie question about cheap 4ch security card
References: <DEB306E3-97D0-461B-A69B-C56FC86F562B@madmac.hu>
In-Reply-To: <DEB306E3-97D0-461B-A69B-C56FC86F562B@madmac.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Riba Zoltán wrote:
> Hi,
>
> I want to get working this card under my Debian
> :(2.6.24-etchnhalf.1-686 on i686)
>
> http://www.zoneminder.com/wiki/index.php/Image:4ch_DVR_card.jpg
>
> But it doesn't want...:
> dmesg:
>
> bttv: driver version 0.9.17 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> bttv: Host bridge needs ETBF enabled.
> bttv: Bt8xx card found (0).
> PCI: Found IRQ 15 for device 0000:00:12.0
> PCI: Sharing IRQ 15 with 0000:00:07.2
> PCI: Sharing IRQ 15 with 0000:00:0b.0
> FPCI: Sharing IRQ 15 with 0000:00:12.1F
> bttv0: Bt878 (rev 17) at 0000:00:12.0, irq: 15, latency: 32, mmio:
> 0xd7001000
> bttv0: using: GrandTec Multi Capture Card (Bt878) [card=77,insmod option]
> bttv0: enabling ETBF (430FX/VP3 compatibilty)
> bttv0: gpio: en=00000000, out=00000000 in=00f360ff [init]
> bt878 #0 [sw]: bus seems to be busy
> bttv0: tuner absent
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv0: PLL: 28636363 => 35468950 .. ok
> bt878: AUDIO driver version 0.0.0 loaded
> bt878: Bt878 AUDIO function found (0).
> PCI: Found IRQ 15 for device 0000:00:12.1
> PCI: Sharing IRQ 15 with 0000:00:07.2
> PCI: Sharing IRQ 15 with 0000:00:0b.0
> PCI: Sharing IRQ 15 with 0000:00:12.0
> bt878_probe: card id=[0x0], Unknown card.Exiting..
> bt878: probe of 0000:00:12.1 failed with error -22
>

> lspci -vn 
no subsystem ID reported  ... and no card id in dmesg ... I'm wondering
if there is no EEPROM on the card .... also wondering if your card is
different (i.e. a new revision) from the card 77 (GrandTec Multi Capture
Card).

What happens if you don't pass a modprobe parameter (i.e. comment out
what you added in your relevant /etc/modprobe.conf file) and let the
card autodetect ... (though, as maybe surmised from my above comment,
I'm guessing a spectacular nothing )
