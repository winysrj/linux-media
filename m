Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45020 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3AQS1n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:27:43 -0500
Message-ID: <50F84276.3080909@iki.fi>
Date: Thu, 17 Jan 2013 20:27:02 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Simon Farnsworth <simon.farnsworth@onelan.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH RFCv10 00/15] DVB QoS statistics API
References: <1358217061-14982-1-git-send-email-mchehab@redhat.com> <20130116152151.5461221c@redhat.com> <CAHFNz9KjG-qO5WoCMzPtcdb6d-4iZk695zp_L3iSeb=ZiWKhQw@mail.gmail.com> <2817386.vHx2V41lNt@f17simon> <20130116200153.3ec3ee7d@redhat.com> <CAHFNz9L-Dzrv=+Z01ndrfK3GmvFyxT6941W4-_63bwn1HrQBYQ@mail.gmail.com> <50F7C57A.6090703@iki.fi> <20130117145036.55745a60@redhat.com> <50F831AA.8010708@iki.fi> <20130117161126.6b2e809d@redhat.com>
In-Reply-To: <20130117161126.6b2e809d@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/17/2013 08:11 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Jan 2013 19:15:22 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 01/17/2013 06:50 PM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 17 Jan 2013 11:33:46 +0200
>>> Antti Palosaari <crope@iki.fi> escreveu:
>>>
>>>> What goes to these units in general, dB conversion is done by the driver
>>>> about always. It is quite hard or even impossible to find out that
>>>> formula unless you has adjustable test signal generator.
>>>>
>>>> Also we could not offer always dBm as signal strength. This comes to
>>>> fact that only recent silicon RF-tuners are able to provide RF strength.
>>>> More traditionally that estimation is done by demod from IF/RF AGC,
>>>> which leads very, very, rough estimation.
>>>>
>>>> So at least for the signal strength it is impossible to require dBm. dB
>>>> for SNR is possible, but it is very hard due to lack of developers
>>>> knowledge and test equipment. SNR could be still forced to look like it
>>>> is in given dB scale. I think it is not big loss even though SNR values
>>>> reported are a little bit wrong.
>>>>
>>>>
>>>> About half year ago I looked how SNR was measured every demod we has:
>>>>
>>>> http://palosaari.fi/linux/v4l-dvb/snr_2012-05-21.txt
>>>>
>>>> as we can see there is currently only two style used:
>>>> 1) 0.1 dB (very common in new drivers)
>>>> 2) unknown (== mostly just raw register values)
>>>
>>> It could make sense to have an FE_SCALE_UNKNOWN for those drivers, if
>>> they can't converted into any of the supported scales.
>>>
>>> Btw, as agreed, on v11:
>>> 	- dB scale changed to 0.001 dB (not sure if this will bring much
>>> gain, as I doubt that demods have that much precision);
>>> 	- removed QoS nomenclature (I hope I didn't forget it left on
>>> 	  some patch);
>>> 	- removed DTV_QOS_ENUM;
>>> 	- counters reset logic is now driver-specific (currently, resetting
>>> 	  it at set_frontend callback on mb8620s);
>>>
>>> I'll be posting the patches after finishing the tests.
>>>
>>> What's left (probably we need more discussions):
>>>
>>> a) a flag to indicate a counter reset (my suggestion).
>>>
>>> Does it make sense? If so, where should it be? At fe_status_t?
>>>
>>> b) per-stats/per-dvb-property error indicator (Devin's suggestion).
>>>
>>> I don't think it is needed for statistics. Yet, it may be interesting for
>>> the other dvb properties.
>>>
>>> So, IMHO, I would do add it like:
>>>
>>> struct dtv_property {
>>>           __u32 cmd;
>>> 	__s32 error;		/* Linux error code when set/get this specific property */
>>>           __u32 reserved[2];
>>>           union {
>>>                   __u32 data;
>>>                   struct dtv_fe_stats st;
>>>                   struct {
>>>                           __u8 data[32];
>>>                           __u32 len;
>>>                           __u32 reserved1[3];
>>>                           void *reserved2;
>>>                  	} buffer;
>>>           } u;
>>>           int result;
>>> } __attribute__ ((packed));
>>>
>>> A patch adding this for statistics should be easy, as there's just one
>>> driver currently implementing it. Making the core and drivers handle
>>> per-property errors can be trickier and will require more work.
>>>
>>> But I'm still in doubt if it does make sense for stats.
>>>
>>> Devin?
>>>
>>> Cheers,
>>> Mauro
>>>
>>
>> There is one issue what I now still think.
>>
>> dvb_prop[2].cmd = DTV_QOS_BIT_ERROR_COUNT;
>> dvb_prop[3].cmd = DTV_QOS_TOTAL_BITS_COUNT;
>> dvb_prop[4].cmd = DTV_QOS_ERROR_BLOCK_COUNT;
>> dvb_prop[5].cmd = DTV_QOS_TOTAL_BLOCKS_COUNT;
>>
>> For me this looks like uncorrected errors are reported as a rate too (as
>> both error count and total count are reported to app). But that is not
>> suitable for reporting uncorrected blocks! It fits fine for BER, but not
>> UCB. If UCB counter is running that fast then picture is totally broken.
>
> UCB is just DTV_QOS_ERROR_BLOCK_COUNT.
>
> PER is DTV_QOS_ERROR_BLOCK_COUNT / DTV_QOS_TOTAL_BLOCKS_COUNT
>
> Not all frontends will of course provide PER.
>
>> Behavior of UCB should remain quite same as it is currently, increases
>> slowly over the time. If you start resetting counters as for BER then
>> UCB is almost all the time 0. User wants to know UCB errors in frame of
>> days rather than minutes.
>
> Hmm... good point.
>
> Let's see when those counters would overflow with u64 (please correct
> if I did any wrong calculus on bc).

It will not overflow, as you maybe remember I calculated few days back 
that u32 will overflow BER counter in 10 seconds in very special case 
where I used 32MHz BW (DVB-C2) and quite optimal (14bit? SNR very big) 
samples from Shannon. If BER will not overflow then no need to care 
about uncorrected blocks as those are much more smaller than BER total bits.

> We have:
> 	2^64 = 18,446,744,073,709,551,616
>
> Assuming a bit rate of 54 Mbps, we have:
> 	bits_per_sec = (54*1024*1024*1024)
> 	bits_per_sec = 57,982,058,496
>
> In this case, the bit error count will overflow in:
> 	time_to_overflow = 2^64 seconds / bits_per_sec =
> 			 = 18,446,744,073,709,551,616 / 57,982,058,496
> 		         = 318,145,725 seconds
> So,
> 	time_to_overflow is more than 3682 days and more than 10 years
>
> DTV_QOS_TOTAL_BLOCKS_COUNT increments slower than DTV_QOS_TOTAL_BITS_COUNT
> (204 * 8 times slower).
>
> So, it would take 318,145,725 * 204 * 8 seconds (or 6,009,419 days) to
> overflow).
>
> IMHO, except for professional applications that would be continuously
> running for more than 10 years , there's no need to be
> careful about overflows.
>
> That said, I still think that the counters should be reset when
> a new channel is tuned (e. g. when set_frontend is called from
> userspace) or when the user requests for a counters reset, as the
> statistics from one channel/transponder are different than the ones
> for other channels/transponders.

Resetting counters when user tunes channel sounds the only correct option.

OK, maybe we will see in near future if that works well or not. I think 
that for calculating of PER it is required to start continuous polling 
to keep up total block counters. Maybe updating UCB counter continously 
needs that too, so it should work.

regards
Antti

-- 
http://palosaari.fi/
