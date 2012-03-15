Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761286Ab2COOjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 10:39:45 -0400
Message-ID: <4F61FF2D.6010505@redhat.com>
Date: Thu, 15 Mar 2012 11:39:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Rui Salvaterra <rsalvaterra@gmail.com>
CC: =?UTF-8?B?RXplcXVpZWwgR2FyY8OtYQ==?= <elezegarcia@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: eMPIA EM2710 Webcam (em28xx) and LIRC
References: <CALjTZvZy4npSE0aELnmsZzzgsxUC1xjeNYVwQ_CvJG59PizfEQ@mail.gmail.com> <CALF0-+Wp03vsbiaJFUt=ymnEncEvDg_KmnV+2OWjtO-_0qqBVg@mail.gmail.com> <CALjTZvYVtuSm0v-_Q7od=iUDvHbkMe4c5ycAQZwoErCCe=N+Bg@mail.gmail.com> <CALF0-+W3HenNpUt_yGxqs+fohcZ22ozDw9MhTWua0B++ZFA2vA@mail.gmail.com> <CALjTZvYJZ32Red-UfZXubB-Lk503DWbHGTL_kEoV4DVDDYJ46w@mail.gmail.com> <4F61C79E.6090603@redhat.com> <CALjTZvZR=Mr-eSVwy=Wd8ToikAX9bG23NLARRw_K0scT-_YeCg@mail.gmail.com>
In-Reply-To: <CALjTZvZR=Mr-eSVwy=Wd8ToikAX9bG23NLARRw_K0scT-_YeCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-03-2012 10:10, Rui Salvaterra escreveu:
> On 15 March 2012 10:42, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>>
>> The em28xx module requires IR support from rc_core, as most em28xx devices
>> support it. It can be compiled without IR support, but, as the em28xx-input
>> is not on a separate module, and it contains some calls to rc_core functions
>> like rc_register_device, modprobe will load rc_core, and rc_core will load
>> the decoders, including lirc_dev.
>>
>> Those modules are small and won't be running if all you have are the webcams.
>> The optimization to not load those modules is not big, so nobody had time
>> yet to do it.
>>
>> Anyway, if you want to fix it, there are two possible approaches:
>>
>> 1) change rc_core to not load the IR decoders at load time, postponing it
>>   to load only if a RC_DRIVER_IR_RAW device is registered via rc_register_device.
>>
>> A patch for it shouldn't be hard. All you need to do is to move ir_raw_init()
>> to rc_register_device() and add a logic there to call it for the first
>> raw device.
>>
>> With such patch, rc_core module will still be loaded.
>>
>> 2) change em28xx-input.c to be a separate module, called only when a device
>> has IR. It will need to have a logic similar to em28xx-dvb and em28xx-alsa
>> modules.
>>
>> It is not hard to write such patch, as most of the logic is already there,
>> but it is not as trivial as approach (1).
>>
>> It probably makes sense for both approaches (1) and (2), as not all boards
>> support "raw" devices. In the case of em28xx, there's no device using "raw"
>> mode, as the em28xx chips provide a hardware IR decoder. So, up to now, we
>> didn't find any em28xx device requiring a software decoder for IR.
>>
>> If you want to write patches for the above, they'll be welcome.
>>
>> I hope that helps.
>>
>> Regards,
>> Mauro
> 
> 
> Hi, Mauro
> 
> I'm sorry for the late reply, I'm at work.
> Thanks a lot for the explanation. Such refactoring seems a bit out of
> my reach, for the time being (though apparently a nice opportunity to
> learn Git-fu, I'm intoxicated by CVS), but at least now I understand
> what is really happening.
> I may try and hack the code a bit and see what comes out, but don't
> wait for me, by all means. I only have a general idea of how the
> kernel works (I understand C, but stopped writing it about ten years
> ago, as I do Java for a living).

Take your time. As I said, a patch for (1) should be easy. So, if you're
interested on trying to do it, it is probably the best thing to start.

If you won't take it, it is likely that some day someone will do it,
but, as this is just a cleanup, the main developers won't likely
have time for doing it, as they're generally busy adding support for 
new hardware.

Regards,
Mauro
> 
> 
> Thanks, once again,
> 
> Rui Salvaterra

