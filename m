Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1Jy69T-000685-AY
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 16:15:49 +0200
Message-ID: <48318B8C.7040900@pilppa.org>
Date: Mon, 19 May 2008 17:15:40 +0300
From: Mika Laitio <lamikr@pilppa.org>
MIME-Version: 1.0
To: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
References: <48310988.8080806@pilppa.org> <4831434A.7000502@chaosmedia.org>
In-Reply-To: <4831434A.7000502@chaosmedia.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Well working S2 cards?
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


> don't know about the hvr-4000
> i have a tt s2-3200 it's cheap and works well, i don't use the CI 
> though, so i can't tell if it's well supported by the driver 
> (multiproto) but besides the CI part i couldn't tell you what's not 
> properly working with this card at the moment..
>
> you'll get some good info on linuxtv wiki : 
> http://www.linuxtv.org/wiki/index.php/DVB-S2_PCI_Cards
>
>
> But if you're going for Sat HD (1080i h264) on linux 64bit, i don't 
> think the dvb device will be the problem as long as it has a working 
> driver.
Yes, I also think the card with best driver support base is THE THING 
here. It seems that for many cards the official DVB drivers and apps are 
now in a little flux state
with multiple each other incompatible kernel driver and userspace app 
interfaces. I hope some resolution is achieved and branches are starting 
to find back to DVB tree.

But nice to hear that all 3 of these cards have changes to work both 
with S and S2.

>> What card you would recommend for the Linux usage and for which one 
>> the drivers are working best? (running on AMD x86-64 with 4850e cpu)
>> And is there any differences in the tuner quality of these cards?
>>   
> With 1080i H264 that you'll get on DVB-T or DVB-S2 (in europe) the 
> main problem will be to properly decode it.
It would be interesting to find some dvb-t usb gadget for playing with 
it and laptop while sitting on the city cafe.
>
> Problems will come either from the stream specifications, unsuported 
> in ffh264, that will produce a jerky decoding or from the lack of CPU 
> of your system..
> Although it seems that latest ffh264 version do use multithreading on 
> those 1080i streams, tested myself on ANIXEHD/ ASTRA PROMO HD streams, 
> ffh264 is not a multithreaded decoder to begin with so in the worst 
> case senario it'll use one single core of your CPU for decoding and 
> then you can get in serious troubles..
Yeah, the 780G chipset I have has something called UVD 2.0 integrated to 
motherboard that should provide hardware acceleration for decoding VC-1, 
H.264 (AVC), WMV, and MPEG-2 sources up to 1080p resolutions. But I pet 
no-one has data available for getting the Linux encoding/decoding 
libraries to support those features.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
