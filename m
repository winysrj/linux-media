Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:58878 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753734Ab1HKUpi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 16:45:38 -0400
Message-ID: <4E443F70.1020106@gmx.net>
Date: Thu, 11 Aug 2011 22:45:36 +0200
From: "P. van Gaans" <w3ird_n3rd@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: S2-3200 switching-timeouts on 2.6.38
References: <4D87AB0F.4040908@t-online.de> <4E431912.2040307@gmx.net>
In-Reply-To: <4E431912.2040307@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2011 01:49 AM, P. van Gaans wrote:
> On 03/21/2011 08:46 PM, Rico Tzschichholz wrote:
>> Hello,
>>
>> I would like to know if there is any intention to include this patch
>> soon? https://patchwork.kernel.org/patch/244201/
>>
>> Currently using 2.6.38 results in switching-timeouts on my S2-3200 and
>> this patch fixes this for good.
>>
>> So it would be nice to have it in 2.6.39.
>>
>> Thank you and best regards,
>> Rico Tzschichholz
>>
>
> Hello,
>
> I also have a Technotrend S2-3200. Bought it 4 years ago. Support for
> Linux seemed to be close at the time. I was a bit of a fool for thinking
> that. It's been on the shelf for most of the time.
>
> Anyway, I've applied that patch, and it turns the S2-3200 from being
> worth hardly more than a paperweight to a functional DVB-S card. I don't
> understand why this patch does not get included.
>
> Only DVB-S2 transponders don't consistently lock properly in kaffeine.
> I'll test what "scan" does tomorrow, see if it's a kaffeine-specific
> problem or not. But even just DVB-S working properly is a massive
> difference for this card.
>
> If it helps, I'll check the silicon version of my card tomorrow as well.
>
> Best regards,
>
> P. van Gaans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

Hello,

Here I am again. My card can be seen at http://tinypic.com/r/2hewzyu/7

Chip:

C2L STB0899 VQ628NDY 220QQ VQ MLT 22 645

So far, scan-s2 won't compile: "scan.c:51:2: error: #error scan-s2 
requires Linux DVB driver API version 5.0!" (I am doing something wrong 
undoubtedly) and I cannot find a way to make w_scan scan specific 
frequencies. It must be possible, but right now I can't figure it out. 
Scan doesn't support DVB-S2.

Perhaps someone else who has an S2-3200 can test this, if not, I will 
eventually get to it I guess, but I'm not entirely sure when.

Best regards,

Pim
