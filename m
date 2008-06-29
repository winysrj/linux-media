Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.172])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <fabreg@gmail.com>) id 1KD4ww-0006q9-VF
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 00:00:48 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1225678wfd.17
	for <linux-dvb@linuxtv.org>; Sun, 29 Jun 2008 15:00:42 -0700 (PDT)
Message-ID: <43d295de0806291500y532e2126qaeec577e406406bd@mail.gmail.com>
Date: Mon, 30 Jun 2008 00:00:42 +0200
From: "Fabrizio Regalli" <fabreg@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <48680114.4030007@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <43d295de0806291420w4b15c20cj25c05e79617d3371@mail.gmail.com>
	<4867FE44.2000901@linuxtv.org>
	<43d295de0806291437i309164eodfc08c293a3237e1@mail.gmail.com>
	<48680114.4030007@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Conexant Device 8852
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

Ok, I've installed the cvs version of driver.

Now I've another problem loading of cx23885 module:

WARNING: Error inserting videobuf_core
(/lib/modules/2.6.25.9/kernel/drivers/media/video/videobuf-core.ko):
Invalid argument
WARNING: Error inserting dvb_core
(/lib/modules/2.6.25.9/kernel/drivers/media/dvb/dvb-core/dvb-core.ko):
Invalid argument
WARNING: Error inserting videobuf_dvb
(/lib/modules/2.6.25.9/kernel/drivers/media/video/videobuf-dvb.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting videobuf_dma_sg
(/lib/modules/2.6.25.9/kernel/drivers/media/video/videobuf-dma-sg.ko):
Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting compat_ioctl32
(/lib/modules/2.6.25.9/kernel/drivers/media/video/compat_ioctl32.ko):
Invalid module format
WARNING: Error inserting v4l1_compat
(/lib/modules/2.6.25.9/kernel/drivers/media/video/v4l1-compat.ko):
Invalid argument
WARNING: Error inserting videodev
(/lib/modules/2.6.25.9/kernel/drivers/media/video/videodev.ko):
Invalid module format
FATAL: Error inserting cx23885
(/lib/modules/2.6.25.9/kernel/drivers/media/video/cx23885/cx23885.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

Maybe I must disable the kernel native module before compile this new one?

Thanks.
Fab

2008/6/29 Michael Krufky <mkrufky@linuxtv.org>:
> 2008/6/29 Michael Krufky <mkrufky@linuxtv.org>:
>>> Fabrizio Regalli wrote:
>>>
>>>> Hello.
>>>>
>>>> I've the follow tv card on my linux box:
>>>>
>>>> 03:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
>>>>       Subsystem: Hauppauge computer works Inc. Device 71d1
>>>>
>>> [snip]
>>>
>>>> I try to use cx23885 driver (with card=<1,2,3,4,5,6> option) but doesn't works.
>>>> Could someone please help me?
>>>>
>>> Use the cx23885 driver from linuxtv.org master branch -- Hauppauge WinTV-HVR1200 will be supported with the 2.6.26 kernel.
>>>
>>> Regards,
>>>
>>> Mike
>>>
>>>
>
> Fabrizio Regalli wrote:
>> Hi Michael
>>
>> thanks for your reply.
>> Which extacly are the files needed? Maybe
>>
>> http://linuxtv.org/downloads/linuxtv-dvb-1.1.1.tar.bz2
>>
>> and
>>
>> http://linuxtv.org/downloads/linuxtv-dvb-apps-1.1.1.tar.bz2
>>
>> Thanks again.
>> Fab
>>
>
> Follow these instructions:
>
> http://linuxtv.org/repo/#mercurial
>
> Good luck!
>
> -Mike
>
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
