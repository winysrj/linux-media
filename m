Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48882 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab1H3Skj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 14:40:39 -0400
Received: by gwaa12 with SMTP id a12so5836322gwa.19
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 11:40:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+s_+Roj2eDz1nagxVQwZtFjpfB5EHX=t7+DLb8foLLzuJu5WA@mail.gmail.com>
References: <CA+s_+RqtWZuj5b55Vk5A==VqbPEnDoqFfSVGtA2n-pdR85mc8g@mail.gmail.com>
	<CA+s_+RrGE2T0H+XSSjg81zh514g1oQePLCfV-y3nJC8DqXjWjQ@mail.gmail.com>
	<CA+s_+RpekDfRSWEQMZObjiR-RTgLeFUk1tc-g6ieQYLzcTqwdw@mail.gmail.com>
	<CAG4Y6eTVzx-jwkzQzR97stabE6KEGh5HGD7UaWnxM333Z3iqxg@mail.gmail.com>
	<CA+s_+Roj2eDz1nagxVQwZtFjpfB5EHX=t7+DLb8foLLzuJu5WA@mail.gmail.com>
Date: Tue, 30 Aug 2011 14:40:38 -0400
Message-ID: <CA+s_+RpF_--oBvUHbwRxFrFuxWHBPtWa9JT1jWZg6ptVuOeu-g@mail.gmail.com>
Subject: Re: Usb digital TV
From: Gabriel Sartori <gabriel.sartori@gmail.com>
To: Alan Carvalho de Assis <acassis@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

  It worked in my i.mx28 based board also!
  In my intel pc I used VLC to play video but I do not have a port of
VLC to my platform.

  Is it possible to use gstreamer to play it?

Thanks a lot!

Gabriel Sartori

2011/8/30 Gabriel Sartori <gabriel.sartori@gmail.com>:
> Thank you Allan!
>
>  Did this device that you use works in 1-seg? I think it is just full-seg!
>
>  Using the Siano based device I tried a better antenna and still
> cannot scan channels.
>  I also tried the patches from Mauro and modified the device firmware
> to isdbt_nova_12mhz_b0.inp forcing it to use mode 6!
>  But it did not work either.
>
>  In my Windows machine it worked without any problem.
>
>  I really don't have much more options.
>
> Thanks in advance!
>
> 2011/8/29 Alan Carvalho de Assis <acassis@gmail.com>:
>> Hi Gabriel,
>>
>> On 8/29/11, Gabriel Sartori <gabriel.sartori@gmail.com> wrote:
>>> It there some devices that has more chance to work on a 2.6.35 kernel
>>> version so I can just cross compile the driver to my mx28 board in a
>>> easier way?
>>>
>>> Thanks in advance.
>>>
>>
>> I suggest you using a device based on dib0700, I got it working on
>> Linux <= 2.6.35:
>> https://acassis.wordpress.com/2009/09/18/watching-digital-tv-sbtvd-in-the-linux/
>>
>> This same device working on i-MXT (Android 2.2 with Linux kernel 2.6.35):
>> http://holoscopio.com/misc/androidtv/
>>
>> Best Regards,
>>
>> Alan
>>
>
