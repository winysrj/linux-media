Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:52514 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaCJFDm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 01:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <19dc01cf3a03$8dba8d80$a92fa880$%debski@samsung.com>
References: <1394181090-16446-1-git-send-email-arun.kk@samsung.com>
	<53199175.6030606@samsung.com>
	<CALt3h7_8=jHq821D_7Fi69bFRNk67S18W6T_SFQeSimpHTdOUA@mail.gmail.com>
	<19dc01cf3a03$8dba8d80$a92fa880$%debski@samsung.com>
Date: Mon, 10 Mar 2014 10:33:41 +0530
Message-ID: <CALt3h7-jiEm_CTCFT83RhF_oV0YuCkxGcfgKv1PDrmmkwn5T-A@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: add init buffer cmd to MFCV6
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"avnd.kiran" <avnd.kiran@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Pawel Osciak <posciak@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Fri, Mar 7, 2014 at 6:18 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hi Arun,
>
>> From: Arun Kumar K [mailto:arunkk.samsung@gmail.com]
>> Sent: Friday, March 07, 2014 12:10 PM
>>
>> Hi Sylwester,
>>
>> On Fri, Mar 7, 2014 at 2:59 PM, Sylwester Nawrocki
>> <s.nawrocki@samsung.com> wrote:
>> > Hi,
>> >
>> > On 07/03/14 09:31, Arun Kumar K wrote:
>> >> From: avnd kiran <avnd.kiran@samsung.com>
>> >>
>> >> Latest MFC v6 firmware requires tile mode and loop filter setting to
>> >> be done as part of Init buffer command, in sync with v7. So, move
>> >> these settings out of decode options reg.
>> >> Also, make this register definition applicable from v6 onwards.
>> >>
>> >> Signed-off-by: avnd kiran <avnd.kiran@samsung.com>
>> >> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> >
>> > Will the driver also work with older version of the firmware after
>> > this change ? If not, shouldn't things like this be done depending on
>> > what firmware version is loaded ?
>> >
>>
>> The original code was for the initial version of v6 firmware.
>> After that the v6 firmware has got many fixes and updates which also
>> got updated in the products running the same.
>> As such there are no official multiple versions of v6 firmware, but
>> only fixes / updates to older version. I will update the s5p-mfc-v6.fw
>> in the linux-firmware also with the newer version. Hope that will be
>> fine.
>
> Unfortunately, I share the same concerns as Sylwester. We have two problems:
> 1) new kernel + old firmware
>
> In this case, someone will update the kernel and find out that video
> decoding is not working. An assumption that I think is common, is that
> updating the kernel should not break anything. If it was working with the
> previous version it should work with the next.
>
> The solution I can suggest is that a check which firmware version is used
> has to be implemented. Maybe you can use the date of firmware to do this
> check?
>

Yes this concern is valid. I think its better to check for firmware date as the
old firmware is already submitted in mainline.

> 2) old kernel + new firmware
>
> I see no clear solution to this problem. If the kernel is old and the
> firmware is behaving differently, the video decoding will not work. I can
> guess that this case would be less common, but still a person can update the
> firmware and leave the old kernel. Changing the firmware can be done by
> replacing a single file.
>
> In addition to the above, you need to clearly specify in the
> linux-firmware.git what is going on. A readme file is a must. Maybe a second
> v6 firmware file should be included?
>


Yes I can put the newer version of v6 firmware also in linux-firmware with a
readme detailing the difference between the same.
I hope this is a valid solution.

Regards
Arun
