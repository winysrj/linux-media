Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ysangkok@gmail.com>) id 1JTMTd-0003Yf-KP
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 20:25:33 +0100
Received: by mu-out-0910.google.com with SMTP id w9so1550499mue.6
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 11:25:30 -0800 (PST)
Message-ID: <15a344380802241125x107f6b3em2623b91c0985c867@mail.gmail.com>
Date: Sun, 24 Feb 2008 20:25:29 +0100
From: Ysangkok <ysangkok@gmail.com>
To: "Simeon Walker" <simbloke@googlemail.com>
In-Reply-To: <cc22fa3b0802240859s36d43938v5acedcece52de49a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <cc22fa3b0802240859s36d43938v5acedcece52de49a@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Perfect kernel/drivers for the Nova-T stick
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

Hello Simeon,

So you're saying that if I want to get my Nova-T stick to work I
should compile 2.6.22.9 instead of 2.6.24.2?

I, too, have a Nova-T stick. I'm using the default Ubuntu kernel, and
git linux-dvb tree. However, it doesn't currently work.

Regards,
Janus Troelsen

2008/2/24, Simeon Walker <simbloke@googlemail.com>:
> Hi,
>
> No, this isn't a question, for me I have the answer, and it is
> 2.6.22.18, the kernel drivers and the latest firmware.
>
> I am using Ubuntu Gutsy and started with their included 2.6.22 kernel.
> When I got the Nova-T stick (now two) I tried the stock Ubuntu kernel
> with no luck. I then tried the linux-dvb drivers with the stock
> kernel. The drivers worked but there was massive stream corruption.
>
> Since then I tried 2.6.23, 2.6.23.13, 2.6.24 (inc .1 and .2). With all
> these versions I have had the dvb-usb driver sometimes complaining
> about the stick being on a USB 1.1 bus, a reboot always fixed that.
> All these version had some problems with mt2060 i2c errors. Sometimes
> I would get USB disconnects, the driver would reload but MythTV
> doesn't even notice it's not recording anymore.
>
> Finally, I don't know why, I tried compiling the latest 2.6.22 kernel.
> The differences are:
>  - There is no stream corruption like the Ubuntu 2.6.22 kernel.
>  - USB2 mode works on every boot.
>  - There are no USB disconnects.
>  - There are no I2C errors.
> The system has been completely stable for for two weeks with not
> single instance of the previous errors.
>
> Is it just me or has anyone else had luck with this kernel version?
>
> Sim
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
