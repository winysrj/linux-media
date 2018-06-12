Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:46214 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932905AbeFLPGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 11:06:37 -0400
Subject: Re: [PATCH] cx231xx: Increase USB bridge bandwidth
To: Matthias Schwarzott <zzam@gentoo.org>,
        Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org,
        mchehab@s-opensource.com
References: <1522699141-11464-1-git-send-email-brad@nextdimension.cc>
 <72df1973-b58c-3bf2-c010-c7c4ea6130e5@gentoo.org>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <9f491971-06a2-b2bf-29e2-80fc152b0f8d@nextdimension.cc>
Date: Tue, 12 Jun 2018 10:06:35 -0500
MIME-Version: 1.0
In-Reply-To: <72df1973-b58c-3bf2-c010-c7c4ea6130e5@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,



On 2018-06-05 13:04, Matthias Schwarzott wrote:
> Am 02.04.2018 um 21:59 schrieb Brad Love:
>> The cx231xx USB bridge has issue streaming QAM256 DVB-C channels.
>> QAM64 channels were fine, but QAM256 channels produced corrupted
>> transport streams.
>>
>> cx231xx alt mode 4 does not provide enough bandwidth to acommodate
>> QAM256 DVB-C channels, most likely DVB-T2 channels would break up
>> as well. Alt mode 5 increases bridge bandwidth to 90Mbps, and
>> fixes QAM256 DVB-C streaming.
>>
> Hi Brad,
>
> I read through the media commits applied in the last weeks.
>
> This patch looks so simple and yet resolves the (for me) unexplainable
> behaviour of the Hauppauge WinTV-HVR-930C-HD. DVB-C reception did only
> produce garbage, but the the same demod driver (si2165) does work
> perfectly in a PCI device.
>
> Thank you for fixing this issue.
>
> Regards
> Matthias

Happy to get this fixed for you :) If you know of any other outstanding
issues
with Hauppauge hardware, feel free to point me at them.

Cheers,

Brad
