Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38725 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaEIFbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 01:31:31 -0400
Message-ID: <536C682D.6060302@gmail.com>
Date: Fri, 09 May 2014 11:01:25 +0530
From: Arun Kumar K <arunkk.samsung@gmail.com>
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kamil Debski <k.debski@samsung.com>
CC: Arun Kumar K <arun.kk@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kiran Avnd <avnd.kiran@samsung.com>
Subject: Re: [PATCH 1/3] [media] s5p-mfc: Add variants to access mfc registers
References: <1398257864-12097-1-git-send-email-arun.kk@samsung.com> <1398257864-12097-2-git-send-email-arun.kk@samsung.com> <005a01cf6ada$f24a15b0$d6de4110$%debski@samsung.com> <CACHYQ-rmcPbH0hk564qVYc2A7e=zvQ=En=+QCY3uUSU5AXYjWQ@mail.gmail.com> <536C5E53.8030007@gmail.com> <536C659E.5030601@gmail.com>
In-Reply-To: <536C659E.5030601@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/09/14 10:50, Tomasz Figa wrote:
> Hi Arun, Paweł,
> 
> On 09.05.2014 06:49, Arun Kumar K wrote:
>> Hi Kamil,
>>
>> On 05/09/14 06:30, Pawel Osciak wrote:
>>> Hi Kamil,
>>>
>>> On Fri, May 9, 2014 at 1:31 AM, Kamil Debski <k.debski@samsung.com> wrote:
>>>>
>>>> Hi Arun,
>>>>
>>>> I think that this driver is getting too complicated now.
>>>>
>>>> First there are separate files for MFC versions, but in addition there are
>>>> many
>>>> IF_MFCVx in there.
>>>
>>> The intention of this patch is to actually get rid of IF_MFCVx
>>> conditionals wherever possible.
>>>
>>>>
>>>> I am curious how many additional lines it would take to
>>>> add s5p_mfc_cmd_v8.* and s5p_mfc_opr_v8.*.
>>>>
>>>> I get the point that this approach may result in less lines added, but
>>>> having a callback specific for version use register pointers specific for
>>>> another version makes the code look unreadable and difficult to maintain.
>>>
>>> Could you please give an example of how this reduces readability?
>>> I personally feel this patch makes things much more readable (see below).
>>>
>>> On the other hand, if we continued without the current method, we
>>> would have to sprinkle
>>> IF_MFCVx macros all around actual functions/operations, instead of
>>> just containing this
>>> to the regs structure, and the only difference in each path would be
>>> register name defines.
>>> I don't feel this would be a better direction to be honest.
>>>
>>> Compare, new, after this patch:
>>>
>>>> +     WRITEL(y_addr, mfc_regs->e_source_first_plane_addr);
>>>> +     WRITEL(c_addr, mfc_regs->e_source_second_plane_addr);
>>>
>>> vs previously, before this patch:
>>>
>>>> -     if (IS_MFCV7(dev)) {
>>>> -             WRITEL(y_addr, S5P_FIMV_E_SOURCE_FIRST_ADDR_V7);
>>>> -             WRITEL(c_addr, S5P_FIMV_E_SOURCE_SECOND_ADDR_V7);
>>>> -     } else {
>>>> -             WRITEL(y_addr, S5P_FIMV_E_SOURCE_LUMA_ADDR_V6);
>>>> -             WRITEL(c_addr, S5P_FIMV_E_SOURCE_CHROMA_ADDR_V6);
>>>> -     }
>>>
>>> And of course adding V8 more would make it even worse with yet another
>>> else if case.
>>>
>>>
>>>> Please give your opinion on another way to add support for v8.
>>>> s5p_mfc_cmd_v8.* and s5p_mfc_opr_v8.* ?
>>>
>>> If we add v7 and v8 files, a majority of their code will look like this:
>>>
>>> s5p_mfc_opr_v6.c:
>>> (...)
>>> void foo_v6(args)
>>> {
>>>     foofun(REGISTER_A_V6);
>>>     barfun(REGISTER_B_V6);
>>> }
>>> (...)
>>>
>>> s5p_mfc_opr_v7.c:
>>> (...)
>>> void foo_v7(args)
>>> {
>>>     foofun(REGISTER_A_V7);
>>>     barfun(REGISTER_B_V7);
>>> }
>>> (...)
>>>
>>> s5p_mfc_opr_v8.c:
>>> (...)
>>> void foo_v8(args)
>>> {
>>>     foofun(REGISTER_A_V8);
>>>     barfun(REGISTER_B_V8);
>>> }
>>> (...)
>>>
>>> I'm not sure this is less error prone and less code...
>>>
>>
>> Adding on to this, I had a discussion with the firmware team and what I
>> got to know is future firmwares are also going to keep the operation
>> sequence same as v6, but there can be more changes in register offsets
>> as they accomodate more features. So if we go with opr_v8.c, we _might_
>> need opr_v9.c also with hardly any change in the code except register
>> offset modifications.
> 
> If register offsets make for most of the differences between particular 
> MFC versions, then probably having the register pointers used instead of 
> base + OFFSET could be useful. Unfortunately we don't have much 
> information about the newer variants, so it's hard to say.
> 
> Btw. I wonder why the firmware team couldn't simply add new registers at 
> the end of the address space, without breaking software compatibility 
> with every new version, even though rest of programming model mostly 
> stays intact, which is a pure nonsense. Couldn't you complain to the for 
> this if you have contact with them? Otherwise this madness will never stop.
> 

I had a detailed discussion with the firmware team regarding this and
updated them the concerns. The need to do it is because, the register
offsets are grouped codec-wise. Like
0x000a H264
0x000d MPEG4
0x000f VP8
etc.

There are some holes given for future register additions also, but
sometimes many additional features are added to specific codecs and also
in the common feature set which doesnt fit in the pre-defined holes. So
as per them, the re-shuffle of registers was done in v8 so as to make it
more clean and taking into consideration future feature requirements.
But again it might have few changes here and there in the next version.
Since these register offsets are not really in our control, this
approach is best in the driver to absorb these changes without many if -
else conditions. The firware team assured me that they will try to avoid
these kind of changes as much as possible in future.

Regards
Arun


> Best regards,
> Tomasz
> 
