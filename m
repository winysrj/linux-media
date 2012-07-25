Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:60577 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933117Ab2GYOsH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jul 2012 10:48:07 -0400
Message-ID: <1343227677.30450.2.camel@tbastian-desktop.localdomain>
Subject: Re: Terratec Cinergy XS 0ccd:0042 (em28xx): Tuning Problem Analog
From: "llarevo@gmx.net" <llarevo@gmx.net>
To: linux-media@vger.kernel.org
Date: Wed, 25 Jul 2012 16:47:57 +0200
In-Reply-To: <1342790769.2231.14.camel@tbastian-desktop.localdomain>
References: <1342790769.2231.14.camel@tbastian-desktop.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I have tuning problem for some analog channels with the Terratec Cinergy
> XS 0ccd:0042. This card is unable to tune into some channels. 
> 
> I have another version of this hardware with the ID's 0ccd:005e.
> Interestingly, this Hardware-Version tunes without any problems all
> available channels. 
> 
> Some channels are not found, but this seems to be not really correlated
> with the frequency, although many of the not found channels are at lower
> frequencies (PAL-BG, channel-list is europe-west):
> 
> 0ccd:005e                 00cd:0042
> E6   (182.25 MHz): ???    E6   (182.25 MHz): no station
> E7   (189.25 MHz): ???    E7   (189.25 MHz): no station
> E8   (196.25 MHz): ???    E8   (196.25 MHz): no station
> E9   (203.25 MHz): ???    E9   (203.25 MHz): no station
> SE6  (140.25 MHz): ???    SE6  (140.25 MHz): no station
> SE7  (147.25 MHz): ???    SE7  (147.25 MHz): no station
> SE8  (154.25 MHz): ???    SE8  (154.25 MHz): no station
> SE9  (161.25 MHz): ???    SE9  (161.25 MHz): no station
> SE10 (168.25 MHz): ???    SE10 (168.25 MHz): no station
> SE11 (231.25 MHz): ???    SE11 (231.25 MHz): no station
> 
> For a complete station-list compare the scantv output attached below.
> 
> According to
> http://www.kernel.org/doc/Documentation/video4linux/CARDLIST.tuner I
> created a parameter file for the proper tuner-setting:
> 
> cat /etc/modprobe.d/tuner_xc2028.conf
> tuner=71
> 
> But this does not solve the problem. 
> 
> The firmware I use is
> -rw-r--r-- 1 root root 65K 11. Jul 21:17 /lib/firmware/xc3028-v27.fw
> 
> The problem occurs both with Fedora 17 and Ubuntu 10.04.
> 
> What could I try next? Any help is appreciated.

Is the patch mentioned here 

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/51169
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/51170

addressing this issue?

Regards
-- 
Felix



