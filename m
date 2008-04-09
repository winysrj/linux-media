Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JjQwx-0004cL-R4
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 05:26:17 +0200
Message-ID: <47FC373F.5060006@iki.fi>
Date: Wed, 09 Apr 2008 06:25:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
References: <7dd90a210804070554t6d8b972xa85eb6a75b0663cd@mail.gmail.com>	
	<47FA3A7A.3010002@iki.fi> <47FAFDDA.4050109@iki.fi>
	<c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>
In-Reply-To: <c4e36d110804081627s21cc5683l886e2a4a8782cd59@mail.gmail.com>
Cc: linux-dvb@linuxtv.org, Benoit Paquin <benoitpaquindk@gmail.com>
Subject: Re: [linux-dvb] USB 1.1 support for AF9015 DVB-T tuner
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Zdenek Kabelac wrote:
> As it looks like my AverTV Hybrid Volar HX is a little bit of no use
> for quite some time -
> and your afatech driver seems to helpfull to many other users - maybe you could
> try to make it help for me as well ??

I can try :)

> What do I need to do ?
> 
> I've got somewhere some old   dvb-usb-af9015.fw size:15913  md5:
> dccbc92c9168cc629a88b34ee67ede7b
> (Unsure where do I get the latest one ?))

version 4.95 is the latest one.
http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/

> Then I have added patch (see attachment) to enable usage of your
> af9015 driver with my USB stick.

Patch worked, but...

> And then I get this dmesg error (with debug=63)
> 
> [40667.159908] af9015_usb_probe: interface:0
> [40667.159915] >>> 10 00 38 00 00 00 00 01
> [40667.159924] af9015: af9015_rw_udev: sending failed: -22 (8/-32512)
> [40668.152369] af9015: af9015_rw_udev: receiving failed: -110

Are you really sure it is Afatech AF9015? Looks like all USB-messages 
are failing. The only thing this could happen is that device is not 
AF9015 or it is badly broken.

> So this doesn't look like a usable for now - is there any chance this
> will ever work ?

Open stick and see chips used. Taking good resolution photo or two from 
PCB (stick motherboard) would be also nice.

> Thanks
> 
> Zdenek

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
