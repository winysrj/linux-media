Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0082.outbound.protection.outlook.com ([104.47.33.82]:8928
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758052AbdLRHc3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 02:32:29 -0500
Subject: Re: [PATCH] media: v4l: xilinx: Use SPDX-License-Identifier
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dhaval Shah <dhaval23031987@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, <hyun.kwon@xilinx.com>,
        <michal.simek@xilinx.com>, <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20171208123537.18718-1-dhaval23031987@gmail.com>
 <20171214205706.GA1856@kroah.com> <20171214194536.2269667d@recife.lan>
 <7952229.SXlKMv2tvC@avalon>
 <CAOymtfJKzs=1xUeJOYqvxhb-o9r=aTUOLOM4-DMUj8xXdD2PUw@mail.gmail.com>
 <20171215072734.6180613b@vento.lan>
From: Michal Simek <michal.simek@xilinx.com>
Message-ID: <9614a2cb-66bf-6689-e6ac-abd24a71bb04@xilinx.com>
Date: Mon, 18 Dec 2017 08:32:12 +0100
MIME-Version: 1.0
In-Reply-To: <20171215072734.6180613b@vento.lan>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

On 15.12.2017 10:27, Mauro Carvalho Chehab wrote:
> Em Fri, 15 Dec 2017 10:55:26 +0530
> Dhaval Shah <dhaval23031987@gmail.com> escreveu:
> 
>> Hi Laurent/Mauro/Greg,
>>
>> On Fri, Dec 15, 2017 at 3:32 AM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hi Mauro,
>>>
>>> On Thursday, 14 December 2017 23:50:03 EET Mauro Carvalho Chehab wrote:
>>>> Em Thu, 14 Dec 2017 21:57:06 +0100 Greg KH escreveu:
>>>>> On Thu, Dec 14, 2017 at 10:44:16PM +0200, Laurent Pinchart wrote:
>>>>>> On Thursday, 14 December 2017 22:08:51 EET Greg KH wrote:
>>>>>>> On Thu, Dec 14, 2017 at 09:05:27PM +0200, Laurent Pinchart wrote:
>>>>>>>> On Thursday, 14 December 2017 20:54:39 EET Joe Perches wrote:
>>>>>>>>> On Thu, 2017-12-14 at 20:37 +0200, Laurent Pinchart wrote:
>>>>>>>>>> On Thursday, 14 December 2017 20:32:20 EET Joe Perches wrote:
>>>>>>>>>>> On Thu, 2017-12-14 at 20:28 +0200, Laurent Pinchart wrote:
>>>>>>>>>>>> On Thursday, 14 December 2017 19:05:27 EET Mauro Carvalho Chehab
>>>>>>>>>>>> wrote:
>>>>>>>>>>>>> Em Fri,  8 Dec 2017 18:05:37 +0530 Dhaval Shah escreveu:
>>>>>>>>>>>>>> SPDX-License-Identifier is used for the Xilinx Video IP and
>>>>>>>>>>>>>> related drivers.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Dhaval Shah <dhaval23031987@gmail.com>
>>>>>>>>>>>>>
>>>>>>>>>>>>> Hi Dhaval,
>>>>>>>>>>>>>
>>>>>>>>>>>>> You're not listed as one of the Xilinx driver maintainers. I'm
>>>>>>>>>>>>> afraid that, without their explicit acks, sent to the ML, I
>>>>>>>>>>>>> can't accept a patch touching at the driver's license tags.
>>>>>>>>>>>>
>>>>>>>>>>>> The patch doesn't change the license, I don't see why it would
>>>>>>>>>>>> cause any issue. Greg isn't listed as the maintainer or copyright
>>>>>>>>>>>> holder of any of the 10k+ files to which he added an SPDX license
>>>>>>>>>>>> header in the last kernel release.
>>>>>>>>>>>
>>>>>>>>>>> Adding a comment line that describes an implicit or
>>>>>>>>>>> explicit license is different than removing the license
>>>>>>>>>>> text itself.
>>>>>>>>>>
>>>>>>>>>> The SPDX license header is meant to be equivalent to the license
>>>>>>>>>> text.
>>>>>>>>>
>>>>>>>>> I understand that.
>>>>>>>>> At a minimum, removing BSD license text is undesirable
>>>>>>>>>
>>>>>>>>> as that license states:
>>>>>>>>>  *    * Redistributions of source code must retain the above copyright
>>>>>>>>>  *      notice, this list of conditions and the following disclaimer.
>>>>>>>>>
>>>>>>>>> etc...
>>>>>>>>
>>>>>>>> But this patch only removes the following text:
>>>>>>>>
>>>>>>>> - * This program is free software; you can redistribute it and/or
>>>>>>>> modify
>>>>>>>> - * it under the terms of the GNU General Public License version 2 as
>>>>>>>> - * published by the Free Software Foundation.
>>>>>>>>
>>>>>>>> and replaces it by the corresponding SPDX header.
>>>>>>>>
>>>>>>>>>> The only reason why the large SPDX patch didn't touch the whole
>>>>>>>>>> kernel in one go was that it was easier to split in in multiple
>>>>>>>>>> chunks.
>>>>>>>>>
>>>>>>>>> Not really, it was scripted.
>>>>>>>>
>>>>>>>> But still manually reviewed as far as I know.
>>>>>>>>
>>>>>>>>>> This is no different than not including the full GPL license in
>>>>>>>>>> every header file but only pointing to it through its name and
>>>>>>>>>> reference, as every kernel source file does.
>>>>>>>>>
>>>>>>>>> Not every kernel source file had a license text
>>>>>>>>> or a reference to another license file.
>>>>>>>>
>>>>>>>> Correct, but the files touched by this patch do.
>>>>>>>>
>>>>>>>> This issue is in no way specific to linux-media and should be
>>>>>>>> decided upon at the top level, not on a per-subsystem basis. Greg,
>>>>>>>> could you comment on this ?
>>>>>>>
>>>>>>> Comment on what exactly?  I don't understand the problem here, care to
>>>>>>> summarize it?
>>>>>>
>>>>>> In a nutshell (if I understand it correctly), Dhaval Shah submitted
>>>>>> https:// patchwork.kernel.org/patch/10102451/ which replaces
>>>>>>
>>>>>> +// SPDX-License-Identifier: GPL-2.0
>>>>>> [...]
>>>>>> - *
>>>>>> - * This program is free software; you can redistribute it and/or modify
>>>>>> - * it under the terms of the GNU General Public License version 2 as
>>>>>> - * published by the Free Software Foundation.
>>>>>>
>>>>>> in all .c and .h files of the Xilinx V4L2 driver
>>>>>> (drivers/media/platform/
>>>>>> xilinx). I have reviewed the patch and acked it. Mauro then rejected it,
>>>>>> stating that he can't accept a change to license text without an
>>>>>> explicit ack from the official driver's maintainers. My position is
>>>>>> that such a change doesn't change the license and thus doesn't need to
>>>>>> track all copyright holders, and can be merged without an explicit ack
>>>>>> from the respective maintainers.
>>>>>
>>>>> Yes, I agree with you, no license is being changed here, and no
>>>>> copyright is either.
>>>>>
>>>>> BUT, I know that most major companies are reviewing this process right
>>>>> now.  We have gotten approval from almost all of the major kernel
>>>>> developer companies to do this, which is great, and supports this work
>>>>> as being acceptable.
>>>>>
>>>>> So it's nice to ask Xilinx if they object to this happening, which I
>>>>> guess Mauro is trying to say here (in not so many words...)  To at least
>>>>> give them the heads-up that this is what is going to be going on
>>>>> throughout the kernel tree soon, and if they object, it would be good to
>>>>> speak up as to why (and if they do, I can put their lawyers in contact
>>>>> with some lawyers to explain it all to them.)
>>>>
>>>> Yes, that's basically what I'm saying.
>>>>
>>>> I don't feel comfortable on signing a patch changing the license text
>>>> without giving the copyright owners an opportunity and enough time
>>>> to review it and approve, or otherwise comment about such changes.
>>>
>>> If I understand you and Greg correctly, you would like to get a general
>>> approval from Xilinx for SPDX-related changes, but that would be a blanket
>>> approval that would cover this and all subsequent similar patches. Is that
>>> correct ? That is reasonable for me.
>>>
>>> In that case, could the fact that commit
>>>
>>> commit 5fd54ace4721fc5ce2bb5aef6318fcf17f421460
>>> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Date:   Fri Nov 3 11:28:30 2017 +0100
>>>
>>>     USB: add SPDX identifiers to all remaining files in drivers/usb/
>>>
>>> add SPDX headers to several Xilinx-authored source files constitute such a
>>> blanket approval ?
>>>
>> I have to do anything here or Once, we get approval from the Michal
>> Simek(michal.simek@xilinx.com) and Hyun.kwon@xilinx.com ACK this patch
>> then it will go into mainline?
> 
> I would wait for their feedback.

Please do not apply this patch till I get approval from legal. I have
already discussed things about SPDX some weeks ago.

Thanks,
Michal
