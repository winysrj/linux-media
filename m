Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:59103 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0CDSdU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Mar 2010 13:33:20 -0500
Message-ID: <4B8FFAEC.1060708@deckpoint.ch>
Date: Thu, 04 Mar 2010 19:24:44 +0100
From: Thomas Kernen <tkernen@deckpoint.ch>
MIME-Version: 1.0
To: Per Lundberg <perlun@gmail.com>
CC: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
Subject: Re: TBS 6980 Dual DVB-S2 PCIe card
References: <loom.20100304T091408-554@post.gmane.org>	 <1267693537.3190.17.camel@pc07.localdom.local> <8f1895b91003040403q52ed1cf4of72a61977d6cdc36@mail.gmail.com>
In-Reply-To: <8f1895b91003040403q52ed1cf4of72a61977d6cdc36@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/4/10 1:03 PM, Per Lundberg wrote:
> Hi Hermann,
>
> On Thu, Mar 4, 2010 at 11:05 AM, hermann pitton<hermann-pitton@arcor.de>  wrote:
>
>>> Has anyone done any attempt at contacting TBS to see if they can release their
>>> changes under the GPLv2? Ideally, they would provide a patch themselves, but it
>>> should be fairly simple to diff the linux/ trees from their provided
>>> linux-s2api-tbs6980.tar.bz2 file with the stock Linux 2.6.32 code... in fact, it
>>> could be that their patch is so trivial that we could just include it in the
>>> stock Linux kernel without asking them for license clarifications... but
>>> obviously, if we can get a green sign from them, it would be even better.
>>
>> It is always the other way round.
>>
>> In the end they need a green sign from us.
>
> Well... I guess we are both right. :-) They need to assert ownership
> and license the code under the GPL, and we need to ensure that the
> quality of the code is high enough (driver is working and does not
> interfer with other parts of the code base...).

We I asked TBS' support about this question they told me they would like 
to get it out under GPL as it has been done with other cards they sell 
but that right now it was not possible due to legal contraints related 
to some of the code in use by some of the chips on the board. No further 
details were provided.

>
>> BTW, the TBS dual seems to be fine on m$, but there are some mysterious
>> lockups without any trace, if used in conjunction with some prior
>> S2/HDTV cards. I can't tell yet, if that it is evenly distributed over
>> amd/ati and nvidia stuff or whatever on win7 ... , but people do spend
>> lifetime in vain on it.
>
> This is pretty interesting, do you have any references? (forum links
> or similar)
> In my particular case, I was thinking about using it as the "only" S2
> card in the machine, later possibly adding a DVB-C card if/when we get
> cable... so, it might not be a problem for me, but it still doesn't
> feel really good. I guess the card is pretty new, so maybe (hopefully)
> it will get fixed by a new firmware release.
>
> Do we have any readers of this list who own the card and use it in
> Linux (with the drivers from TBS)? Could you please share your
> experiences: is the picture quality good? Sound? Does the tuner work
> well? (e.g. can you receive all channels you normally receive...)

Yes I use the card. Have had it for a couple of months now running in a 
server that acts as a video head-end in my test network. I only tune to 
specific transponders when I boot the server so I can't really comment 
on tuning time and related issues. Yes I've used it for S and S2 feeds 
and so far it fits my requirements.

HTH,
Thomas
