Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout03.t-online.de ([194.25.134.81])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1K8i33-00049q-No
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 22:45:02 +0200
Message-ID: <48582245.2020407@t-online.de>
Date: Tue, 17 Jun 2008 22:44:53 +0200
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: Francesco <ml@punkrockworld.it>
References: <48565075.6040400@iinet.net.au>	<200806161343.16372.eggert@hugsaser.is>	<4856FE3D.6040400@t-online.de>
	<4857CF64.8080201@punkrockworld.it>
In-Reply-To: <4857CF64.8080201@punkrockworld.it>
Cc: linux-dvb@linuxtv.org
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

Hi, Francesco

Francesco schrieb:
>> Looks like there currently are many people having problems.
>> Allow me to give some background info:
>>
>> Something that is not in the datasheet:
>> The tda10046 automatically tries to load the firmware from an eeprom at the
>> second I2C port. This does *not* need to be triggered by the driver. The timeout
>> seems to be very long. In the past, this happened:
>> If the driver tries to access the tuner while the download is not finished, there
>> is a collision on the I2C bus. This can corrupt both, the firmware and the tuner
>> initialization. In the case of the tda8275a, the result can be that it turns off
>> its 16MHz reference output which is used for the tda10046 as well. This blocks the
>> i2c bus and the only way to recover is a complete power cycle.
>> This is why i made the driver try to get the firmware as soon as possible.
>> Otherwise it is not possible to access the tuner - at least on some boards.
>>
>> Few days ago, a user reported that the firmware download seems to be retriggered
>> in some cases. This might occur if something opens the dvb device while the download
>> is not finished. If it is the case, we need to lock the download.
>> Another dangerous thing is the address mapping of the firmware eeprom: it is
>> controlled by a GPIO pin. If this pin changes while the download is running, we are
>> lost.
>>
>> Best regards
>>    Hartmut
> 
> I've found a little workaround (not a solution, but...) for this problem 
> for my Asus7131H...
> 
> Simply adding "saa7134-dvb" to /etc/modules, make a successful firmware 
> loading on boot.
> (My system is an Ubuntu 7.10)
> 
> 
Could you post the relevant sections of the kernel log for both cases, successful
and unsuccessful firmware load? Please extract the entire board initialization.
Also: do you run a client / server based application (with early start of the server)?

Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
