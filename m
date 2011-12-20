Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55247 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1LTSBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 13:01:12 -0500
Message-ID: <4EF0CD63.20003@iki.fi>
Date: Tue, 20 Dec 2011 20:01:07 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR 3.3] HDIC HD29L2 DMB-TH demodulator driv
References: <4EE929D5.6010106@iki.fi> <4EF0A92B.6010504@redhat.com> <4EF0ACFD.6040903@iki.fi> <201112201725.57381.pboettcher@kernellabs.com> <4EF0C2F5.6040801@iki.fi>
In-Reply-To: <4EF0C2F5.6040801@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/20/2011 07:16 PM, Antti Palosaari wrote:
> On 12/20/2011 06:25 PM, Patrick Boettcher wrote:
>> Hi all,
>>
>> On Tuesday 20 December 2011 16:42:53 Antti Palosaari wrote:
>>> Adding those to API is not mission impossible. Interleaver is only
>>> new parameter and all the rest are just extending values. But my
>>> time is limited... and I really would like to finally got Anysee
>>> smart card reader integrated to USB serial first.
>>
>> And if it is added we should not forget to discuess whether DMB-TH is
>> the "right" name. (If this has already been addressed in another thread
>> please point me to it).
>>
>> I know this standard under at least 2 different names: CTTB and DTMB.
>>
>> Which is the one to choose?
>
> Yes, there is many names and it is not even clear for me what are
> differences between names. I called it DMB-TH since existing Kernel
> drivers have selected that name.
>
> http://en.wikipedia.org/wiki/CMMB
> http://en.wikipedia.org/wiki/DTMB
> http://en.wikipedia.org/wiki/Digital_Multimedia_Broadcasting
> http://en.wikipedia.org/wiki/Digital_Terrestrial_Multimedia_Broadcast
>
> CMMB
> CTTB
> DTMB (DTMB-T/H, DMB-T/H)
> DMB (T-DMB)

DMB seems to be much different so drop it out. DTMB seems to be official 
term for DMB-T/H. CMMB seems to be for small devices (mobile), maybe 
subset of DTMB. Finally I have CTTB and DTMB which seems to be 
equivalents. DTMB is more common.

So I end up for the DTMB. I give my vote for that.


regards
Antti
-- 
http://palosaari.fi/
