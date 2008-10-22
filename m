Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KsaEg-0005ki-Kk
	for linux-dvb@linuxtv.org; Wed, 22 Oct 2008 11:42:42 +0200
From: Darron Broad <darron@kewl.org>
To: Antti Palosaari <crope@iki.fi>
In-reply-to: <48FEF474.50803@iki.fi> 
References: <48FE2872.3070105@podzimek.org> <48FE3553.5080009@iki.fi>
	<48FE6351.2000805@podzimek.org> <10307.1224636523@kewl.org>
	<48FEF474.50803@iki.fi>
Date: Wed, 22 Oct 2008 10:42:34 +0100
Message-ID: <13799.1224668554@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MSI DigiVox mini II V3.0 stopped working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <48FEF474.50803@iki.fi>, Antti Palosaari wrote:

hi

>Darron Broad kirjoitti:
>> In message <48FE6351.2000805@podzimek.org>, Andrej Podzimek wrote:
>>> One more little note about the firmware:
>>>
>>> 	[andrej@xandrej firmware]$ sha1sum dvb-usb-af9015.fw
>>> 	6a0edcc65f490d69534d4f071915fc73f5461560  dvb-usb-af9015.fw
>>>
>>> That file can be found here: http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/dvb-usb-af9015.fw
>>>
>>> Is it the right one? Shell I try something else?
>> 
>> Lo
>> 
>> try this patch (WARNING, although I have one of these devices
>> and this looked to fix it, I have no idea what this actually means).
>
>Your patch means it does not reconnect stick on USB-bus after firmware 
>download. Anyhow, it should reconnect, there is reconnect command in 
>af9015 driver after firmware download. I have no idea why functionality 
>seems to be changed (stick does not reconnect anymore).

Okay, thanks for the overview.

>Is that problem coming from after new Kernel?

This is using:
Linux beethoven 2.6.27.1 #1 SMP PREEMPT Thu Oct 16 23:29:23 BST 2008 x86_64 GNU/Linux

With http://linuxtv.org/hg/v4l-dvb/

I admit, I haven't used this device as yet, it's been in my
drawer waiting to be tested on my TV computer, hopefully
replacing two tuners with the one stick... :-)

Thanks for your efforts with this.

Cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
