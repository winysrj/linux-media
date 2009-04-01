Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:31150 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbZDAEIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Apr 2009 00:08:05 -0400
Received: by rv-out-0506.google.com with SMTP id f9so3384615rvb.1
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2009 21:08:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49D297C6.40600@linuxtv.org>
References: <3731df090903301437k49c310bbha71946ab14c0d6c9@mail.gmail.com>
	 <412bdbff0903301447k6bd27643s7188c17e3ca2798e@mail.gmail.com>
	 <3731df090903310957v119c97e9vbca96d1293d3aef8@mail.gmail.com>
	 <37219a840903311344o56723b21m84e67adcbd1011cd@mail.gmail.com>
	 <3731df090903311516p39ffc59ftfcf161fa158f6dbb@mail.gmail.com>
	 <49D297C6.40600@linuxtv.org>
Date: Tue, 31 Mar 2009 21:08:03 -0700
Message-ID: <3731df090903312108s2b14fae9if0f02b11cbab39da@mail.gmail.com>
Subject: Re: Correct signal strength and SNR output for DViCO FusionHDTV7 Dual
	Express?
From: Dave Johansen <davejohansen@gmail.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 31, 2009 at 3:23 PM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> Dave Johansen wrote:
>>
>> On Tue, Mar 31, 2009 at 1:44 PM, Michael Krufky <mkrufky@linuxtv.org>
>> wrote:
>>
>>>
>>> On Tue, Mar 31, 2009 at 12:57 PM, Dave Johansen <davejohansen@gmail.com>
>>> wrote:
>>>
>>>>
>>>> On Mon, Mar 30, 2009 at 2:47 PM, Devin Heitmueller
>>>> <devin.heitmueller@gmail.com> wrote:
>>>>
>>>>>
>>>>> On Mon, Mar 30, 2009 at 5:37 PM, Dave Johansen <davejohansen@gmail.com>
>>>>> wrote:
>>>>>
>>>>>>
>>>>>> I am trying to get a MythTV setup working with a DViCO FusionHDTV7
>>>>>> Dual Express using Mythbuntu 8.10 and I have been able to generate a
>>>>>> channels.conf file using the latest v4l-dvb source code and the scan
>>>>>> utility that comes with the dvb-utils in Mythbuntu (the dvbscan
>>>>>> utility in latest dvb-apps source code give me the error "Unable to
>>>>>> query frontend status"). I am also able to watch channels using
>>>>>> mplayer, but the the problem is that MythTV does not identify any
>>>>>> channels. I am able to watch channels using MythTV, but I have to
>>>>>> manually enter the channel data since the tuning is not working.
>>>>>>
>>>>>> The belief is that the signal strength and SNR output must be
>>>>>> incorrect and that is causing the problem with MythTV. I would like to
>>>>>> help get this fixed, so others don't have the problems that I have run
>>>>>> into, so what can I do to help get the signal strength and SNR outputs
>>>>>> working?
>>>>>>
>>>>>> If it's helpful, I have attached an example output using azap with one
>>>>>> of the channels that I can watch with mplayer:
>>>>>>
>>>>>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>>>> tuning to 503028615 Hz
>>>>>> video pid 0x0011, audio pid 0x0014
>>>>>> status 01 | signal e000 | snr e450 | ber 00000000 | unc 00000000 |
>>>>>> status 1f | signal 00ff | snr 00ff | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00ff | snr 00ff | ber 00000ab7 | unc 00000ab7 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>> status 1f | signal 00fa | snr 00fa | ber 00000000 | unc 00000000 |
>>>>>> FE_HAS_LOCK
>>>>>>
>>>>>> Thanks,
>>>>>> Dave
>>>>>>
>>>>>
>>>>> Hello Dave,
>>>>>
>>>>> There has been an ongoing discussion about the representation of SNR
>>>>> and strength to applications such as MythTV.  Currently it is very
>>>>> inconsistent across drivers.
>>>>>
>>>>> To my knowledge, MythTV does not rely on either of these fields during
>>>>> its scanning.  It relies entirely on the FE_HAS_LOCK to make it's
>>>>> determination.
>>>>>
>>>>> You should probably see what additional logging capabilities are
>>>>> available in MythTV.
>>>>>
>>>>> Also, you might want to see if you can change the lock timeout in your
>>>>> application, as some applications may have the interval set to a value
>>>>> too short, which results in it timing out before the lock is acquired.
>>>>>
>>>>> Devin
>>>>>
>>>>> --
>>>>> Devin J. Heitmueller
>>>>> http://www.devinheitmueller.com
>>>>> AIM: devinheitmueller
>>>>>
>>>>>
>>>>
>>>> So, I tried upping the tuning timeout and MythTV under Mythbuntu 8.10
>>>> was able to find 1 of the channels (I can find 19 using scan and
>>>> azap).
>>>>
>>>> I then downloaded the Mythbuntu 9.04 beta and got a new antenna. The
>>>> driver worked out of the box so I didn't need to download/compile the
>>>> latest v4l-dvb drivers, and it was able to get all 19 channels in
>>>> MythTV (it took 3 or 4 scans to finally get them all). I realize that
>>>> that wasn't the most scientific approach, so I will re-try with the
>>>> old antenna and see if it was the antenna or the software upgrade that
>>>> did the trick.
>>>>
>>>> I also tried cranking the tuning timeout up to 15 seconds and it still
>>>> couldn't find all of the channels during every scan. Is that something
>>>> that I need to look into from a MythTV perspective? Or is there
>>>> something wrong with v4l-dvb that's causing that?
>>>>
>>>
>>> MythTV's channel scanner is undergoing heavy changes in svn trunk.  By
>>> the time 0.22 comes out, I suspect that MythTV's built-in channel
>>> scanner will be of a much higher quality.
>>>
>>> If you want to get all your channels, I recommend creating your own
>>> channels.conf using the command line utilities, then import that into
>>> mythtv via mythtv-setup.
>>>
>>> -Mike
>>>
>>>
>>
>> I have been using scan to generate a channels.conf file and then using
>> that file when scanning for channels in MythTV, but it only ever finds
>> a few of the channels when I do a scan in MythTV (even though I can
>> watch all of them without problems using MythTV). I just repeated the
>> scan with the imported channels.conf file a few times and it finally
>> picked up all of the channels. Is that normal/expected behavior? Or
>> should I just not worry about it until 0.22 comes out?
>
> I love MythTV, but I'll be honest -- I have NEVER had a good experience
> where I could do a single channel scan and end up with all the right
> channels.
>
> I usually have to jump through various hoops, editing channel configurations
> in mythtv-setup, mythweb, and phpmyadmin.  I do not recommend any of that to
> regular users, and ALWAYS back up your database before messing with your
> tables.
>
> I've been told that the channel scanner in 0.22 is *much* better.  I pulled
> it in from the svn branch a few days ago and I already built it and did a
> first run test... It looks much better, but I didnt inspect closely yet.
>
> If I see any way to improve the channel scanning, I will submit patches to
> the mythtv folks.  However, based on what I've seen so far, I have a feeling
> that the work Dan's been doing lately will result in much more robust
> channel scanning for the future.
>
> I'd say to just go with what works for now, and when 0.22 comes out, try
> again.
>
> Regards,
>
> Mike
>

Sounds good. Thanks for the help,
Dave
