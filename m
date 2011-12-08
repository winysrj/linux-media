Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45196 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab1LHIbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Dec 2011 03:31:23 -0500
Received: by lagp5 with SMTP id p5so590785lag.19
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2011 00:31:21 -0800 (PST)
Message-ID: <4EE075D5.1060408@gmail.com>
Date: Thu, 08 Dec 2011 09:31:17 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <4EDF6262.2000209@redhat.com> <4EDF6AB8.5050201@gmail.com> <4EDF7048.2030304@redhat.com> <4EDF7758.3080309@gmail.com> <4EDF7E23.3090904@redhat.com>
In-Reply-To: <4EDF7E23.3090904@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/11 15:54, Mauro Carvalho Chehab wrote:
>>
>> lin-tv ~ # lsusb | grep "Bus 002"
>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 002 Device 008: ID 2040:1605 Hauppauge
>
>
> There's nothing at the DVB core returning -ENOSPC.
>
> Try to add just one line to a channels file, like this one:
>     C 602000000 6900000 NONE QAM256
>
> (this is the transponder that failed with w_scan. You could also use one
> of the transponders where you got a pid timeout with scan)
>
> Then call scan with this file, using strace:
>
> $ strace -e ioctl dvbscan channelfile
>
> This would allow to see what ioctl returned -ENOSPC (error -28).
>
> Regards,
> Mauro
>

Mauro,

I made a small script to check if the w_scan results are consistent:

#!/bin/bash
for i in `seq 1 20`;
do
     w_scan -fc -c NO 1>> scan$i.log 2>> scan$i.log
done

And I get outputs like this  (the timing numbers differs of course 
somewhat between different runs):

<snip>

586000: sr6900 (time: 10:21) sr6875 (time: 10:23)
594000: sr6900 (time: 10:26) sr6875 (time: 10:28)
602000: sr6900 (time: 10:31) (time: 10:32) signal ok:
     QAM_256  f = 602000 kHz S6900C999
Info: NIT(actual) filter timeout
610000: sr6900 (time: 10:44) sr6875 (time: 10:47)
618000: sr6900 (time: 10:49) sr6875 (time: 10:52)
626000: sr6900 (time: 10:54) sr6875 (time: 10:57)

<snip>

Then I did the test that you suggested:

lin-tv ~ # strace -e ioctl dvbscan -fc test_channel_file

scanning test_channel_file
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ioctl(3, FE_GET_INFO, 0x60b180)         = 0
initial transponder 602000000 6900000 0 5
 >>> tune to: 602000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
ioctl(3, FE_SET_FRONTEND, 0x7fff0581fb20) = 0
ioctl(3, FE_READ_STATUS, 0x7fff0581fb4c) = 0
ioctl(3, FE_READ_STATUS, 0x7fff0581fb4c) = 0
ioctl(4, DMX_SET_FILTER, 0x7fff0581e930) = 0
ioctl(5, DMX_SET_FILTER, 0x7fff0581e930) = 0
ioctl(6, DMX_SET_FILTER, 0x7fff0581e930) = 0
WARNING: filter timeout pid 0x0011
ioctl(5, DMX_STOP, 0x23)                = 0
WARNING: filter timeout pid 0x0000
ioctl(4, DMX_STOP, 0x23)                = 0
WARNING: filter timeout pid 0x0010
ioctl(6, DMX_STOP, 0x23)                = 0
dumping lists (0 services)
Done.


I did not get the:

602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
         QAM_256  f = 602000 kHz S6900C999
start_filter:1415: ERROR: ioctl DMX_SET_FILTER failed: 28 No space left 
on device
Info: NIT(actual) filter timeout

that I got before. The changes I made from before was 1) I unmounted the 
USB disk and 2) I rebuild the xc5000 module where I removed the

mutex_lock(&xc5000_list_mutex);

and

mutex_unlock(&xc5000_list_mutex);

lines according to the discussion in the " ...  em28xx: initial support 
for HAUPPAUGE HVR-930C again" thread.

/Fredrik


