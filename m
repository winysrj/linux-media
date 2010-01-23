Return-path: <linux-media-owner@vger.kernel.org>
Received: from n23.bullet.mail.ukl.yahoo.com ([87.248.110.140]:34822 "HELO
	n23.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932092Ab0AWM1N convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jan 2010 07:27:13 -0500
Message-ID: <64386.84610.qm@web24702.mail.ird.yahoo.com>
References: <4B580AB2.6030005@brdo.cz> <20100121094943.GA2332@localhost.lan> <4B595C40.2070001@brdo.cz> <4B5ABE5F.50704@skynet.be>
Date: Sat, 23 Jan 2010 12:27:10 +0000 (GMT)
From: Alistair Thomas <astavale@yahoo.co.uk>
Subject: Re: bt878 card: no sound and only xvideo support in 2.6.31 bttv 0.9.18
To: linux-media@vger.kernel.org
In-Reply-To: <4B5ABE5F.50704@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>





Xof wrote:
> I had the same problem in 2008 when somebody changed tvaudio and I did
> not realize I had to specify new options in my /etc/modprobe.d/bttv.conf
> file.  I wonder why 'bttv card=100' is not enough to specify the
> hardware and what to do with it.  There is an entry 'Hercules Smart TV
> Stereo' in bttv-cards.c.  I am not sure what can be done with
> autodetecting chips on an unknown board.  I agree, this is probably
> complex matter but this mix of specification and autodetection is suspect.

I agree, auto detection for sound seems not to work too well for BT878 cards.

To get sound I have to set modprobe options:

options tda9887 qss=0
options tuner pal=i

although the card is auto detected:

bttv0: detected: Pinnacle PCTV [card=39], PCI subsystem ID is 11bd:0012
bttv0: using: Pinnacle PCTV Studio/Rave [card=39,autodetected]

Would be great if there was a method to fix this.

Al



      

