Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34667 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932212AbbFAIIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Jun 2015 04:08:06 -0400
Received: by wgv5 with SMTP id 5so107085537wgv.1
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2015 01:08:05 -0700 (PDT)
Message-ID: <556C12E3.3020404@gmail.com>
Date: Mon, 01 Jun 2015 09:08:03 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: mchehab@osg.samsung.com, patrick.boettcher@posteo.de
Subject: Re: [PATCH v2 1/4] b2c2: Add option to skip the first 6 pid filters
References: <1433009409-5622-1-git-send-email-jdenson@gmail.com> <1433009409-5622-2-git-send-email-jdenson@gmail.com> <556BF852.80202@iki.fi>
In-Reply-To: <556BF852.80202@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 01/06/15 07:14, Antti Palosaari wrote:
> On 05/30/2015 09:10 PM, Jemma Denson wrote:
>> The flexcop bridge chip has two banks of hardware pid filters -
>> an initial 6, and on some chip revisions an additional bank of 32.
>>
>> A bug is present on the initial 6 - when changing transponders
>> one of two PAT packets from the old transponder would be included
>> in the initial packets from the new transponder. This usually
>> transpired with userspace programs complaining about services
>> missing, because they are seeing a PAT that they would not be
>> expecting. Running in full TS mode does not exhibit this problem,
>> neither does using just the additional 32.
>>
>> This patch adds in an option to not use the inital 6 and solely use
>> just the additional 32, and enables this option for the SkystarS2
>> card. Other cards can be added as required if they also have
>> this bug.
>
> Why not to use strategy where 32 pid filter is used as a priority and 
> that buggy 6 pid filter is used only when 32 pid filter is not 
> available (or it is already 100% in use)?
>

Yes, that might work, I hadn't though of just swapping them around - 
thanks. It would however assume that the 0x0000 PAT feed is requested 
early on enough that it always sits within the bank of 32 and nothing 
else is too bothered by the odd out of order packet.

The only concern I have got is if there is any other oddness in the 
first 6 - this card is the only flexcop based card with dvb-s2 and there 
is a lack of stream with high bitrate transponders (>approx. 45Mbps), 
which we think might due to the hardware pid filter. The card apparently 
works fine under the windows driver so it's a case of trying to work out 
what that might be doing differently. It's quite speculative at the 
moment but I'm hoping this patch might help with that and I'm waiting 
for some feedback on that - I'm stuck with 28.2E which doesn't hold 
anything interesting.

At the moment it doesn't really matter too much having only 32 filters 
rather than the full 38 - it does switch to full-TS once it runs out of 
hardware filters, and the only issue with full-TS is that the flexcop 
can't pass a TS with more than 45Mbps (but they aren't working at the 
moment anyway)


Jemma.
