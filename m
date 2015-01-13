Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1054 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751347AbbAMNPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 08:15:09 -0500
Message-ID: <54B51A57.8010905@metafoo.de>
Date: Tue, 13 Jan 2015 14:15:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/16] [media] adv7180: Add support for different chip
References: <1421150481-30230-1-git-send-email-lars@metafoo.de> <54B517C3.3070205@xs4all.nl>
In-Reply-To: <54B517C3.3070205@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/13/2015 02:04 PM, Hans Verkuil wrote:
> Hi Lars,
>
> On 01/13/15 13:01, Lars-Peter Clausen wrote:
>> The adv7180 is part of a larger family of chips which all implement
>> different features from a feature superset. This patch series step by step
>> extends the current adv7180 with features from the superset that are
>> currently not supported and gradually adding support for more variations of
>> the chip.
>>
>> The first half of this series contains fixes and cleanups while the second
>> half adds new features and support for new chips.
>
> For patches 1-7, 9-13 and 16:
>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> I need a bit more time to review patches 8 and 15. Ping me if you haven't
> heard from me by Friday.

Thanks.

>
> BTW: is the adv7183 part of the same family? There is a separate i2c driver
> for it in the kernel, so I was wondering if that could be merged into this
> driver eventually.

Yea, I had a look at that, and it appears to be related, but it seems to be 
some early derivative and things weren't fully standardized at that point, 
so while similar there were a few notable differences. And I think the 
adv7183 isn't even produced anymore. So I didn't try to integrate it yet, 
but it might happen at some point.

>
> Did you check with authors of drivers that use the adv7180 to ensure nothing
> broke? They should be pinged about this at least.

I tried to make sure that the register write sequence is still the same for 
adv7180 as it was before. The only thing new for the adv7180 is support for 
the new controls.

I'll include a few more people on Cc for v2.

- Lars
