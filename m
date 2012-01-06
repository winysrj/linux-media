Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40879 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab2AFRY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 12:24:27 -0500
Received: by ggdk6 with SMTP id k6so792885ggd.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 09:24:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHVY3emBazYtJKwz-PaJKZQe3Gbi7JBP_zJp-Y-3n=ZtTR2JHg@mail.gmail.com>
References: <CAHVY3e=Q8yRdXhgsoPBX-dvCHY=uF7adCievYoOTg15cOF6xGw@mail.gmail.com>
 <CAHVY3emBazYtJKwz-PaJKZQe3Gbi7JBP_zJp-Y-3n=ZtTR2JHg@mail.gmail.com>
From: Mario Ceresa <mrceresa@gmail.com>
Date: Fri, 6 Jan 2012 18:24:05 +0100
Message-ID: <CAHVY3empEzXBCw+GM_vjE+yXovTfY5KQ6=RyOfkBUEiM_2F7OQ@mail.gmail.com>
Subject: Re: sveon stv40 usb stick
To: V4L Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Last updates. It works with em28xx module from v4l git as a card 19:
# modprobe em28xx card=19
# echo 1b80 e309 > /sys/bus/usb/drivers/em28xx/new_id

[plugged in the usb] and

$ mplayer -tv device=/dev/video0:input=1:norm=PAL:alsa:immediatemode=0:audiorate=48000:amode=1:adevice=hw.2
tv://

But I have no audio... I will open a new thread only for the audio problem!

Best,
Mario


On 6 January 2012 15:52, Mario Ceresa <mrceresa@gmail.com> wrote:
> Hi again!
>
> following the thread "em28xx: new board id [eb1a:5051]" between Reuben
> and Gareth I was able to advance a little:
>
> 1) I opened the usn stick and my chipsets are:
> - USB interface: em2860
> - Audio ADC: emp202
> - Video ADC: saa7118h (philips)
>
> 2) I confirm that the stock em28xx driver can recognize the usb stick
> but needs to specify a card manually as an option.
>
> 3) Using "modprobe em18xx card=19" (which corresponds to
> "EM2860/SAA711X Reference Design") I can go so far as to get a
> /dev/video0, but the preview is black no matter what i do.
>
> 4) I was able to eventually compile the v4l drivers but, as soon as I
> inject the driver, I get a kernel oops (attached). I made no change to
> the code obtained with git.
>
> I won't even mind to write some code myself, but I really have no idea
> where to begin with!
>
> Thanks in advance for any help you might provide,
>
> Best,
>
> Mario
>
>
>
> On 3 January 2012 20:44, Mario Ceresa <mrceresa@gmail.com> wrote:
>> Hello everybody!
>> I recently bougth a Sveon STV40 usb stick to capture analogic video
>> (http://www.sveon.com/fichaSTV40.html)
>> I can use it in windows but my linux box (Fedora 16 -
>> 3.1.6-1.fc16.x86_64 - gcc 4.6.2) can't recognize it.
>> Is there any way I can fix this?
>>
>> These are the results of my investigation so far:
>>
>> 1) It is identified by lsusb as an Afatech board (1b80:e309) with an
>> Empia 2861 chip (from dmesg and windows driver inf file)
>> 2) I experimented with em28xx  because the chipset was empia and with
>> af9015 because I found that the stv22 was supported
>> (http://linuxtv.org/wiki/index.php/Afatech_AF9015). In both cases
>> after I manually added the vendor:id to /sys/bus/usb/drivers/ driver
>> started but in the end I was not able to succeed. With em28xx I could
>> go as far as having a /dev/video0 device but with no signal and the
>> dmesg log said to ask here for help :) . With the af9015 I had an
>> early stop.
>> 3) Both the logs are attached.
>> 4) I used the driver shipped with the fedora stock kernel because I
>> can't compile the ones that I get from
>> git://linuxtv.org/media_build.git. I have an error at:
>>
>> CC [M]  media_build/v4l/as3645a.o
>> media_build/v4l/as3645a.c: In function 'as3645a_probe':
>> media_build/v4l/as3645a.c:815:2: error: implicit declaration of
>> function 'kzalloc' [-Werror=implicit-function-declaration]
>> media_build/v4l/as3645a.c:815:8: warning: assignment makes pointer
>> from integer without a cast [enabled by default]
>> cc1: some warnings being treated as errors
>>
>> Thank you in advance for any help you might provide on this issue!
>>
>> ,Best regards
>>
>> Mario
