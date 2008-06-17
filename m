Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa013msr.fastwebnet.it ([85.18.95.73])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ml@punkrockworld.it>) id 1K8cX0-0004I2-R3
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 16:51:40 +0200
Received: from [192.168.0.12] (37.244.170.61) by aa013msr.fastwebnet.it
	(8.0.013.8) id 48321BEA037957AA for linux-dvb@linuxtv.org;
	Tue, 17 Jun 2008 16:50:58 +0200
Message-ID: <4857CF64.8080201@punkrockworld.it>
Date: Tue, 17 Jun 2008 16:51:16 +0200
From: Francesco <ml@punkrockworld.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48565075.6040400@iinet.net.au>	<200806161343.16372.eggert@hugsaser.is>
	<4856FE3D.6040400@t-online.de>
In-Reply-To: <4856FE3D.6040400@t-online.de>
Subject: Re: [linux-dvb] unstable tda1004x firmware loading
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

> Looks like there currently are many people having problems.
> Allow me to give some background info:
> 
> Something that is not in the datasheet:
> The tda10046 automatically tries to load the firmware from an eeprom at the
> second I2C port. This does *not* need to be triggered by the driver. The timeout
> seems to be very long. In the past, this happened:
> If the driver tries to access the tuner while the download is not finished, there
> is a collision on the I2C bus. This can corrupt both, the firmware and the tuner
> initialization. In the case of the tda8275a, the result can be that it turns off
> its 16MHz reference output which is used for the tda10046 as well. This blocks the
> i2c bus and the only way to recover is a complete power cycle.
> This is why i made the driver try to get the firmware as soon as possible.
> Otherwise it is not possible to access the tuner - at least on some boards.
> 
> Few days ago, a user reported that the firmware download seems to be retriggered
> in some cases. This might occur if something opens the dvb device while the download
> is not finished. If it is the case, we need to lock the download.
> Another dangerous thing is the address mapping of the firmware eeprom: it is
> controlled by a GPIO pin. If this pin changes while the download is running, we are
> lost.
> 
> Best regards
>    Hartmut

I've found a little workaround (not a solution, but...) for this problem 
for my Asus7131H...

Simply adding "saa7134-dvb" to /etc/modules, make a successful firmware 
loading on boot.
(My system is an Ubuntu 7.10)




Francesco Ferrario
- Chimera project -
- www.chimeratv.it -

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
