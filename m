Return-path: <linux-media-owner@vger.kernel.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]:62967
	"EHLO mail.lemonrind.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbZI0MOF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 08:14:05 -0400
Subject: Re: HVR-2200 Australia DVB-T
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Alex Ferrara <alex@receptiveit.com.au>
In-Reply-To: <4AAF97D1.8030905@kernellabs.com>
Date: Sun, 27 Sep 2009 22:14:04 +1000
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <999AB6C7-EC50-4307-8E92-F6DAC5190C43@receptiveit.com.au>
References: <CED52FAC-4C8D-416C-B00E-5662F1F63E85@receptiveit.com.au> <4AAF97D1.8030905@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

I have just found the official Australian broadcast data  
(acma.gov.au). I did find something interesting.

In all cases except for channel TEN, the analog channel and digital  
channel are located on adjacent channels. Channel TEN has a huge  
channel separation.

I have confirmed that the channel center frequencies in my  
channels.conf file are correct.

Are we looking at a 7Mhz vs 8Mhz channel separation issue?

aF

On 15/09/2009, at 11:34 PM, Steven Toth wrote:

>> WIN TV
>> Canberra: 
>> 767500000 
>> :INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
>> :FEC_3_4 
>> :QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
>> 33:36:1
>
>
>> root@kaylee:~/.tzap# tzap "WIN TV Canberra"
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> reading channels from file '/root/.tzap/channels.conf'
>> tuning to 767500000 Hz
>> video pid 0x0021, audio pid 0x0024
>> status 00 | signal a9a9 | snr 002e | ber 0000ffff | unc 00000000 |
>> status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
>> status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
>> status 00 | signal ffff | snr 0000 | ber 0000ffff | unc 00000000 |
>>
>> Any help would be appreciated.
>
> Sounds like a tuning issue. Either the Antenna is bad or the  
> channels.conf doesn't represent the actual center frequency or the  
> channel or the tuner / demod code is buggy.
>
> Other people are having success with DVB-T HVR2200 so it's either a  
> bug that gets exposed by your environment or something else. mkrufky  
> has some tuner improvements pending for merge which are not in the  
> saa7164 tree yet, you might want to hold for a few days for these.
>
> The other thing to double check is that the freqs in your channels  
> conf do actually represent the center of the DVB-T channel. I  
> suspect they do, but double check for good measure using the  
> official Australian DVB-T antenna docs.
>
> -- 
> Steven Toth - Kernel Labs
> http://www.kernellabs.com

