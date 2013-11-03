Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54830 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab3KCQkA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 11:40:00 -0500
Message-ID: <52767C57.1050509@iki.fi>
Date: Sun, 03 Nov 2013 18:39:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org
Subject: Re: DVB-C2
References: <1382462076-29121-1-git-send-email-guest@puma.are.ma> <21095.747.879743.551447@morden.metzler> <20131103093155.50b59b45@samsung.com>
In-Reply-To: <20131103093155.50b59b45@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.11.2013 13:31, Mauro Carvalho Chehab wrote:
> Em Wed, 23 Oct 2013 00:57:47 +0200
> Ralph Metzler <rjkm@metzlerbros.de> escreveu:
>> I am wondering if anybody looked into API extensions for DVB-C2 yet?
>> Obviously, we need some more modulations, guard intervals, etc.
>> even if the demod I use does not actually let me set those (only auto).
>>
>> But I do need to set the PLP and slice ID.
>> I currently set them (8 bit each) by combining them into the 32 bit
>> stream_id (DTV_STREAM_ID parameter).
>
> I don't like the idea of combining them into a single field. One of the
> reasons is that we may have endianness issues.
>
> So, IMHO, the better is to add a new property for slice ID.

I tried to understand what that data slice is. So what I understand, it 
is layer to group PLPs, in order to get one wide OFDM channel as OFDM is 
more efficient when channel bw increases.

So, in order to tune "stream" channel on DVB-C2 system, you *must* know 
(in a order from radio channel to upper layers):
frequency
bandwidth
slice ID
PLP ID

Is that right?

I wonder if PLP IDs are defined so that there could not be overlapping 
PLP IDs in a system... But if not, then defining slice ID is likely 
needed. And if and when slice ID is needed to know before PLP ID, it is 
even impossible to resolve slice ID from PLP ID.

>> By using the stream id like this and not having (or being able) to set
>> the rest of the new parameters I only have to add SYS_DVBC2 to the delivery systems
>> right now. But the new parameters should be added for completeness and if we want to
>> be able to scan we will need calls to read out L1 signalling information.
>
> I didn't have time yet to dig into DVB-C2 API, but I think that the better
> is to add full support to all modulation types, guard intervals, etc, even
> knowing that most modern demods work fine on auto mode those days.
>
> As you said, scan should be able to read out L1 signaling information.
>
> Also, as we're starting to talk about modulator drivers, all those properties
> should be specified on the modulator.
>
> So, it makes sense to add a patch there extending the API (both
> documentation and frontend.h) to fully support DVB C2.

regards
Antti

-- 
http://palosaari.fi/
