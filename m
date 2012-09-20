Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:36965 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2ITT2y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 15:28:54 -0400
Message-ID: <505B6E74.9020605@schinagl.nl>
Date: Thu, 20 Sep 2012 21:28:52 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1348167437-4371-1-git-send-email-oliver+list@schinagl.nl> <505B6B4E.8010006@iki.fi>
In-Reply-To: <505B6B4E.8010006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-09-12 21:15, Antti Palosaari wrote:
> On 09/20/2012 09:57 PM, oliver@schinagl.nl wrote:
>> From: Oliver Schinagl <oliver@schinagl.nl>
>>
>> This is initial support for the Asus MyCinema U3100Mini Plus. The driver
>> in its current form gets detected and loads properly.
>>
>> Scanning using dvbscan works without problems, Locking onto a channel
>> using tzap also works fine. Only playback using tzap -r + mplayer was
>> tested and was fully functional.
>>
>> It uses the af9035 USB Bridge chip, with an af9033 demodulator. The 
>> tuner
>> used is the FCI FC2580.
>>
>> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
>
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
> It is OK. Mauro, please merge to the master.
I do hope that it won't be a problem as I based it on your 
remotes/origin/for_v3.7-13
>
> @Oliver, you didn't fixed FC2580 useless braces as I requested. 
> Anyway, I will sent another patch to fix it later. Action not required.
Ah, I did comment on that change in my reply on your comments; a 
re-paste from that:

Checkpatch did not trigger on this. Which makes sense. Kernel 
CodingStyle is in very strong favor of K&R and from what I know from 
K&R, K&R strongly discourage not using braces as it is very likely to 
introduce bugs. Wikipedia has a small mention of this, then again 
wikipedia is wikipedia.

I will take it out of you really want it out, but with checkpatch not 
even complaining, I would think this as an improvement. :D
>

>
> regards
> Antti

