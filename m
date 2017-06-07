Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:52270 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751413AbdFGURv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 16:17:51 -0400
Subject: Re: Unknown symbol put_vaddr_frames when using media_build
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <6ea4c402-9523-2345-9dd3-0fb041f07f27@gentoo.org>
 <20170607152338.5fd9d304@vento.lan>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <cc11c60e-8a39-35f2-06e5-f6cb3b1cdc4a@gentoo.org>
Date: Wed, 7 Jun 2017 22:17:50 +0200
MIME-Version: 1.0
In-Reply-To: <20170607152338.5fd9d304@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 07.06.2017 um 20:23 schrieb Mauro Carvalho Chehab:
> Em Tue, 9 May 2017 06:56:25 +0200
> Matthias Schwarzott <zzam@gentoo.org> escreveu:
> 
>> Hi!
>>
>> Whenever I compile the media drivers using media_build against a recent
>> kernel, I get this message when loading them:
>>
>> [    5.848537] media: Linux media interface: v0.10
>> [    5.881440] Linux video capture interface: v2.00
>> [    5.881441] WARNING: You are using an experimental version of the
>> media stack.
>> ...
>> [    6.166390] videobuf2_memops: Unknown symbol put_vaddr_frames (err 0)
>> [    6.166394] videobuf2_memops: Unknown symbol get_vaddr_frames (err 0)
>> [    6.166396] videobuf2_memops: Unknown symbol frame_vector_destroy (err 0)
>> [    6.166398] videobuf2_memops: Unknown symbol frame_vector_create (err 0)
>>
>> That means I am not able to load any drivers being based on
>> videobuf2_memops without manual actions.
>>
>> I used kernel 4.11.0, but it does not matter which kernel version
>> exactly is used.
>>
>> My solution for that has been to modify mm/Kconfig of my kernel like
>> this and then enable FRAME_VECTOR in .config
> 
> Well, if you build your Kernel with VB2 compiled, you'll have it.
> 
Sure.

So my question is:
How good do the kernel origin vb2 and the media_build vb2 play together?

Will modprobe always choose the media_build one?
Or will "make install" just overwrite the original file?

>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 9b8fccb969dc..cfa6a80d1a0a 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -701,7 +701,7 @@ config ZONE_DEVICE
>>           If FS_DAX is enabled, then say Y.
>>
>>  config FRAME_VECTOR
>> -       bool
>> +       tristate "frame vector"
>>
>>  config ARCH_USES_HIGH_VMA_FLAGS
>>         bool
>>
>> But I do not like that solution.
>> I would prefer one of these solutions:
>>
>> 1. Have media_build apply its fallback the same way as for older kernels
>> that do not even have the the FRAME_VECTOR support.
>>
>> 2. Get the above patch merged (plus description etc.).
>>
>> What do you think?
> 
> (1) is probably simpler, but you would need to play with the building
> system in order to identify if the current Kernel has it enabled or not.
> That could be tricky.
> 
> I suspect people won't accept (2), as it doesn't make sense upstream.

Well, it would be equivalent to options like CRC16 in folder lib.

Regards
Matthias
