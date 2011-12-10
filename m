Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:52459 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab1LJNn2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Dec 2011 08:43:28 -0500
Received: by lagp5 with SMTP id p5so1453223lag.19
        for <linux-media@vger.kernel.org>; Sat, 10 Dec 2011 05:43:26 -0800 (PST)
Message-ID: <4EE361FB.9090301@gmail.com>
Date: Sat, 10 Dec 2011 14:43:23 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <4EDF6262.2000209@redhat.com> <4EDF6AB8.5050201@gmail.com> <4EDF7048.2030304@redhat.com> <4EDF7758.3080309@gmail.com> <4EDF7E23.3090904@redhat.com> <4EE075D5.1060408@gmail.com> <4EE0D169.5040607@redhat.com>
In-Reply-To: <4EE0D169.5040607@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/11 16:02, Mauro Carvalho Chehab wrote:
>
>> #!/bin/bash
>> for i in `seq 1 20`;
>> do
>> w_scan -fc -c NO 1>> scan$i.log 2>> scan$i.log
>> done
>>
>> And I get outputs like this (the timing numbers differs of course 
>> somewhat between different runs):
>>
>> <snip>
>>
>> 586000: sr6900 (time: 10:21) sr6875 (time: 10:23)
>> 594000: sr6900 (time: 10:26) sr6875 (time: 10:28)
>> 602000: sr6900 (time: 10:31) (time: 10:32) signal ok:
>> QAM_256 f = 602000 kHz S6900C999
>> Info: NIT(actual) filter timeout
>> 610000: sr6900 (time: 10:44) sr6875 (time: 10:47)
>> 618000: sr6900 (time: 10:49) sr6875 (time: 10:52)
>> 626000: sr6900 (time: 10:54) sr6875 (time: 10:57)
>>
>> <snip>
>>
>> Then I did the test that you suggested:
>>
>> lin-tv ~ # strace -e ioctl dvbscan -fc test_channel_file
>>
>> scanning test_channel_file
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> ioctl(3, FE_GET_INFO, 0x60b180) = 0
>> initial transponder 602000000 6900000 0 5
>> >>> tune to: 602000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
>> ioctl(3, FE_SET_FRONTEND, 0x7fff0581fb20) = 0
>> ioctl(3, FE_READ_STATUS, 0x7fff0581fb4c) = 0
>> ioctl(3, FE_READ_STATUS, 0x7fff0581fb4c) = 0
>> ioctl(4, DMX_SET_FILTER, 0x7fff0581e930) = 0
>> ioctl(5, DMX_SET_FILTER, 0x7fff0581e930) = 0
>> ioctl(6, DMX_SET_FILTER, 0x7fff0581e930) = 0
>> WARNING: filter timeout pid 0x0011
>> ioctl(5, DMX_STOP, 0x23) = 0
>> WARNING: filter timeout pid 0x0000
>> ioctl(4, DMX_STOP, 0x23) = 0
>> WARNING: filter timeout pid 0x0010
>> ioctl(6, DMX_STOP, 0x23) = 0
>> dumping lists (0 services)
>> Done.
>>
>>
>> I did not get the:
>>
>> 602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
>> QAM_256 f = 602000 kHz S6900C999
>> start_filter:1415: ERROR: ioctl DMX_SET_FILTER failed: 28 No space 
>> left on device
>
>
>> Info: NIT(actual) filter timeout
>>
>> that I got before. The changes I made from before was 1) I unmounted 
>> the USB disk and 2) I rebuild the xc5000 module where I removed the
>>
>> mutex_lock(&xc5000_list_mutex);
>>
>> and
>>
>> mutex_unlock(&xc5000_list_mutex);
>>
>> lines according to the discussion in the " ... em28xx: initial 
>> support for HAUPPAUGE HVR-930C again" thread.
>
> Ok, let's go by parts.
>
> 1) error 28 at DMX_SET_FILTER is really due to lack of space at the 
> USB bus. I've
> double-checked at the code. The only place there where it could occur 
> is when
> dvb_dmxdev_feed_start() calls feed->ts->start_filtering(feed->ts), 
> with should be
> pointing to em28xx_start_feed(), with tries to start the transfer 
> URB's at
> em28xx_init_isoc() by calling usb_submit_urb(). This is the only 
> routine that returns
> ENOSPC on this chain.
>
> It is very likely that what fixed it were the removal of the USB disk.
>
> 2)  There is an error at the bandwidth calculus on xc5000. It is 
> likely that it is
> using a 6MHz bandwidth filter, instead of a 8MHz one.
>
> Please try the enclosed patch.
>
>
> [media] xc5000,tda18271c2dd: Fix bandwidth calculus
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/common/tuners/xc5000.c 
> b/drivers/media/common/tuners/xc5000.c
> index ecd1f95..8279c45 100644
> --- a/drivers/media/common/tuners/xc5000.c
> +++ b/drivers/media/common/tuners/xc5000.c
> @@ -708,9 +708,9 @@ static int xc5000_set_params(struct dvb_frontend *fe,
>               * is equal to 0.15 for Annex A, and 0.13 for annex C
>               */
>              if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
> -                bw = (params->u.qam.symbol_rate * 13) / 10;
> +                bw = (params->u.qam.symbol_rate * 113) / 100;
>              else
> -                bw = (params->u.qam.symbol_rate * 15) / 10;
> +                bw = (params->u.qam.symbol_rate * 115) / 100;
>              if (bw <= 6000000) {
>                  priv->bandwidth = BANDWIDTH_6_MHZ;
>                  priv->video_standard = DTV6;
> diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c 
> b/drivers/media/dvb/frontends/tda18271c2dd.c
> index de544f6..b66ca29 100644
> --- a/drivers/media/dvb/frontends/tda18271c2dd.c
> +++ b/drivers/media/dvb/frontends/tda18271c2dd.c
> @@ -1158,9 +1158,9 @@ static int set_params(struct dvb_frontend *fe,
>           * is equal to 0.15 for Annex A, and 0.13 for annex C
>           */
>          if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
> -            bw = (params->u.qam.symbol_rate * 13) / 10;
> +            bw = (params->u.qam.symbol_rate * 113) / 100;
>          else
> -            bw = (params->u.qam.symbol_rate * 15) / 10;
> +            bw = (params->u.qam.symbol_rate * 115) / 100;
>          if (bw <= 6000000)
>              Standard = HF_DVBC_6MHZ;
>          else if (bw <= 7000000)
>
>

Changing 13 -> 113 and 15 -> 115 in the two files made no difference. 
However, I figured out that the

586000: sr6900 (time: 10:22) sr6875 (time: 10:24)
594000: sr6900 (time: 10:27) sr6875 (time: 10:30)
602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
         QAM_256  f = 602000 kHz S6900C999
start_filter:1417: ERROR: ioctl DMX_SET_FILTER failed: 28 No space left 
on device
Info: NIT(actual) filter timeout
610000: sr6900 (time: 10:55) sr6875 (time: 10:57)
618000: sr6900 (time: 11:00) sr6875 (time: 11:02)
626000: sr6900 (time: 11:05) sr6875 (time: 11:07)

output from w_scan only happends the first time after the driver has 
been loaded. That is, running this script

#!/bin/bash
for i in `seq 1 20`;
do
     rmmod em28xx_dvb
     rmmod em28xx
     sleep 5
     modprobe em28xx
     sleep 5
     echo $i
     w_scan -fc -c NO 1>> scan_out$i.log 2>> scan_err$i.log
done

will give the error above for every scan but if I don't reload the 
driver then I will get the output:

594000: sr6900 (time: 10:26) sr6875 (time: 10:29)
602000: sr6900 (time: 10:31) (time: 10:32) signal ok:
         QAM_256  f = 602000 kHz S6900C999
Info: NIT(actual) filter timeout
610000: sr6900 (time: 10:45) sr6875 (time: 10:47)
618000: sr6900 (time: 10:50) sr6875 (time: 10:52)

for i >=2 instead.

I noticed the new patches you are working with on the list. Let me know 
I there's something I can test?

Regards,

/Fredrik










