Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558Ab1LHPCQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Dec 2011 10:02:16 -0500
Message-ID: <4EE0D169.5040607@redhat.com>
Date: Thu, 08 Dec 2011 13:02:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Fredrik Lingvall <fredrik.lingvall@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <4EDF6262.2000209@redhat.com> <4EDF6AB8.5050201@gmail.com> <4EDF7048.2030304@redhat.com> <4EDF7758.3080309@gmail.com> <4EDF7E23.3090904@redhat.com> <4EE075D5.1060408@gmail.com>
In-Reply-To: <4EE075D5.1060408@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08-12-2011 06:31, Fredrik Lingvall wrote:
> On 12/07/11 15:54, Mauro Carvalho Chehab wrote:
>>>
>>> lin-tv ~ # lsusb | grep "Bus 002"
>>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>>> Bus 002 Device 008: ID 2040:1605 Hauppauge
>>
>>
>> There's nothing at the DVB core returning -ENOSPC.
>>
>> Try to add just one line to a channels file, like this one:
>> C 602000000 6900000 NONE QAM256
>>
>> (this is the transponder that failed with w_scan. You could also use one
>> of the transponders where you got a pid timeout with scan)
>>
>> Then call scan with this file, using strace:
>>
>> $ strace -e ioctl dvbscan channelfile
>>
>> This would allow to see what ioctl returned -ENOSPC (error -28).
>>
>> Regards,
>> Mauro
>>
>
> Mauro,
>
> I made a small script to check if the w_scan results are consistent:
>
> #!/bin/bash
> for i in `seq 1 20`;
> do
> w_scan -fc -c NO 1>> scan$i.log 2>> scan$i.log
> done
>
> And I get outputs like this (the timing numbers differs of course somewhat between different runs):
>
> <snip>
>
> 586000: sr6900 (time: 10:21) sr6875 (time: 10:23)
> 594000: sr6900 (time: 10:26) sr6875 (time: 10:28)
> 602000: sr6900 (time: 10:31) (time: 10:32) signal ok:
> QAM_256 f = 602000 kHz S6900C999
> Info: NIT(actual) filter timeout
> 610000: sr6900 (time: 10:44) sr6875 (time: 10:47)
> 618000: sr6900 (time: 10:49) sr6875 (time: 10:52)
> 626000: sr6900 (time: 10:54) sr6875 (time: 10:57)
>
> <snip>
>
> Then I did the test that you suggested:
>
> lin-tv ~ # strace -e ioctl dvbscan -fc test_channel_file
>
> scanning test_channel_file
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> ioctl(3, FE_GET_INFO, 0x60b180) = 0
> initial transponder 602000000 6900000 0 5
>  >>> tune to: 602000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
> ioctl(3, FE_SET_FRONTEND, 0x7fff0581fb20) = 0
> ioctl(3, FE_READ_STATUS, 0x7fff0581fb4c) = 0
> ioctl(3, FE_READ_STATUS, 0x7fff0581fb4c) = 0
> ioctl(4, DMX_SET_FILTER, 0x7fff0581e930) = 0
> ioctl(5, DMX_SET_FILTER, 0x7fff0581e930) = 0
> ioctl(6, DMX_SET_FILTER, 0x7fff0581e930) = 0
> WARNING: filter timeout pid 0x0011
> ioctl(5, DMX_STOP, 0x23) = 0
> WARNING: filter timeout pid 0x0000
> ioctl(4, DMX_STOP, 0x23) = 0
> WARNING: filter timeout pid 0x0010
> ioctl(6, DMX_STOP, 0x23) = 0
> dumping lists (0 services)
> Done.
>
>
> I did not get the:
>
> 602000: sr6900 (time: 10:32) (time: 10:33) signal ok:
> QAM_256 f = 602000 kHz S6900C999
> start_filter:1415: ERROR: ioctl DMX_SET_FILTER failed: 28 No space left on device

> Info: NIT(actual) filter timeout
>
> that I got before. The changes I made from before was 1) I unmounted the USB disk and 2) I rebuild the xc5000 module where I removed the
>
> mutex_lock(&xc5000_list_mutex);
>
> and
>
> mutex_unlock(&xc5000_list_mutex);
>
> lines according to the discussion in the " ... em28xx: initial support for HAUPPAUGE HVR-930C again" thread.

Ok, let's go by parts.

1) error 28 at DMX_SET_FILTER is really due to lack of space at the USB bus. I've
double-checked at the code. The only place there where it could occur is when
dvb_dmxdev_feed_start() calls feed->ts->start_filtering(feed->ts), with should be
pointing to em28xx_start_feed(), with tries to start the transfer URB's at
em28xx_init_isoc() by calling usb_submit_urb(). This is the only routine that returns
ENOSPC on this chain.

It is very likely that what fixed it were the removal of the USB disk.

2)  There is an error at the bandwidth calculus on xc5000. It is likely that it is
using a 6MHz bandwidth filter, instead of a 8MHz one.

Please try the enclosed patch.


[media] xc5000,tda18271c2dd: Fix bandwidth calculus
     
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index ecd1f95..8279c45 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -708,9 +708,9 @@ static int xc5000_set_params(struct dvb_frontend *fe,
  			 * is equal to 0.15 for Annex A, and 0.13 for annex C
  			 */
  			if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-				bw = (params->u.qam.symbol_rate * 13) / 10;
+				bw = (params->u.qam.symbol_rate * 113) / 100;
  			else
-				bw = (params->u.qam.symbol_rate * 15) / 10;
+				bw = (params->u.qam.symbol_rate * 115) / 100;
  			if (bw <= 6000000) {
  				priv->bandwidth = BANDWIDTH_6_MHZ;
  				priv->video_standard = DTV6;
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index de544f6..b66ca29 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1158,9 +1158,9 @@ static int set_params(struct dvb_frontend *fe,
  		 * is equal to 0.15 for Annex A, and 0.13 for annex C
  		 */
  		if (fe->dtv_property_cache.rolloff == ROLLOFF_13)
-			bw = (params->u.qam.symbol_rate * 13) / 10;
+			bw = (params->u.qam.symbol_rate * 113) / 100;
  		else
-			bw = (params->u.qam.symbol_rate * 15) / 10;
+			bw = (params->u.qam.symbol_rate * 115) / 100;
  		if (bw <= 6000000)
  			Standard = HF_DVBC_6MHZ;
  		else if (bw <= 7000000)


