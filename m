Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab2AOVIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Jan 2012 16:08:42 -0500
Message-ID: <4F13404D.2020001@redhat.com>
Date: Sun, 15 Jan 2012 19:08:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] DVBv5 tools version 0.0.1
References: <4F08385E.7050602@redhat.com> <4F0CAF53.3090802@iki.fi> <4F0CB512.7010501@redhat.com> <4F131CD8.2060602@iki.fi> <4F13312B.8060005@iki.fi>
In-Reply-To: <4F13312B.8060005@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-01-2012 18:03, Antti Palosaari escreveu:
> On 01/15/2012 08:37 PM, Antti Palosaari wrote:
>> On 01/11/2012 12:00 AM, Mauro Carvalho Chehab wrote:
>>> On 10-01-2012 19:36, Antti Palosaari wrote:
>>>> Behaviour of new FE is strange for my eyes. Could you look and
>>>> explain if it is intentional?
>>
>> I still see that it changes delivery system automatically to the DVB-T.
>>
>>
>> That is the latest commit:
>>
>> commit 149709f5b8a4a8678401facb5c670119751f6087
>> Author: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Date: Fri Jan 13 11:46:36 2012 -0200
>>
>> [media] dvb-core: preserve the delivery system at cache clear
>>
>> The changeset 240ab508aa is incomplete, as the first thing that
>> happens at cache clear is to do a memset with 0 to the cache.
>>
>> So, the delivery system needs to be explicitly preserved there.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>>
>> And here is log:
>>
>> [crope@localhost code]$ ./tmp/v4l-utils/utils/dvb/dvb-fe-tool
>> --set-delsys=DVBC/ANNEX_A
>> Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
>> CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6
>> CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO
>> CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256
>> CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
>> DVB API Version 5.5, Current v5 delivery system: DVBT
>> Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
>> Changing delivery system to: DVBC/ANNEX_A
>> [crope@localhost code]$ scan ../fi-Oulu-c
>> scanning ../fi-Oulu-c
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 330000000 6875000 0 4
>> initial transponder 370000000 6875000 0 4
>> initial transponder 362000000 6875000 0 4
>> initial transponder 354000000 6875000 0 4
>> initial transponder 346000000 6875000 0 4
>> initial transponder 338000000 6875000 0 4
>> initial transponder 322000000 6875000 0 4
>> initial transponder 314000000 6875000 0 4
>> initial transponder 378000000 6875000 0 4
>> initial transponder 306000000 6875000 0 4
>> initial transponder 298000000 6875000 0 4
>> initial transponder 290000000 6875000 0 5
>> initial transponder 274000000 6875000 0 5
>> initial transponder 266000000 6875000 0 5
>> initial transponder 258000000 6875000 0 5
>> initial transponder 250000000 6875000 0 5
>> initial transponder 242000000 6875000 0 5
>>  >>> tune to: 330000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_128
>> ^CERROR: interrupted by SIGINT, dumping partial result...
>> dumping lists (0 services)
>> Done.
>> [crope@localhost code]$ scan ../fi-Oulu-c
>> scanning ../fi-Oulu-c
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> initial transponder 330000000 6875000 0 4
>> initial transponder 370000000 6875000 0 4
>> initial transponder 362000000 6875000 0 4
>> initial transponder 354000000 6875000 0 4
>> initial transponder 346000000 6875000 0 4
>> initial transponder 338000000 6875000 0 4
>> initial transponder 322000000 6875000 0 4
>> initial transponder 314000000 6875000 0 4
>> initial transponder 378000000 6875000 0 4
>> initial transponder 306000000 6875000 0 4
>> initial transponder 298000000 6875000 0 4
>> initial transponder 290000000 6875000 0 5
>> initial transponder 274000000 6875000 0 5
>> initial transponder 266000000 6875000 0 5
>> initial transponder 258000000 6875000 0 5
>> initial transponder 250000000 6875000 0 5
>> initial transponder 242000000 6875000 0 5
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> WARNING: frontend type (OFDM) is not compatible with requested tuning
>> type (QAM)
>> ERROR: initial tuning failed
>> dumping lists (0 services)
>> Done.
>> [crope@localhost code]$ ./tmp/v4l-utils/utils/dvb/dvb-fe-tool
>> --set-delsys=DVBC/ANNEX_A
>> Device Sony CXD2820R (DVB-T/T2) (/dev/dvb/adapter0/frontend0) capabilities:
>> CAN_2G_MODULATION CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6
>> CAN_FEC_7_8 CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO
>> CAN_INVERSION_AUTO CAN_MUTE_TS CAN_QAM_16 CAN_QAM_64 CAN_QAM_256
>> CAN_QAM_AUTO CAN_QPSK CAN_TRANSMISSION_MODE_AUTO
>> DVB API Version 5.5, Current v5 delivery system: DVBT
>> Supported delivery systems: [DVBT] DVBT2 DVBC/ANNEX_A
>> Changing delivery system to: DVBC/ANNEX_A
>> [crope@localhost code]$
> 
> That seems to be due to cxd2820r bug introduced by multi-frontend to single-frontend change.

Ok. Could you please fix it and send us a patch?

> But now I got that error:
> [crope@localhost code]$ ./tmp/v4l-utils/utils/dvb/dvb-fe-tool --set-delsys=DVBC/ANNEX_A
> Device or resource busy while opening /dev/dvb/adapter0/frontend0
> Changing delivery system to: DVBC/ANNEX_A
> Segmentation fault (core dumped)

There was a bug at the error code handling on dvb-fe-tool: basically, if it can't open
a device, it were using a NULL pointer. It was likely fixed by this commit:

http://git.linuxtv.org/v4l-utils.git/commit/1f669eed5433d17df4d8fb1fa43d2886f99d3991


> [crope@localhost code]$
> 
> I opened device using VLC and then try to switch it to correct mode. But it crash and no picture.
> 
> Antti
> 
> 

Regards,
Mauro
