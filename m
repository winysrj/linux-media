Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:32248 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZCIKSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 06:18:24 -0400
Received: by ti-out-0910.google.com with SMTP id d10so1099392tib.23
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2009 03:18:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5e9665e10903081636l3e3afda0ofc215a082631927c@mail.gmail.com>
References: <49B141F6.6040301@maxwell.research.nokia.com>
	 <5e9665e10903081636l3e3afda0ofc215a082631927c@mail.gmail.com>
Date: Mon, 9 Mar 2009 15:48:20 +0530
Message-ID: <dfeb90390903090318kfc92a05k153f3840c3b699b2@mail.gmail.com>
Subject: Re: OMAP3 ISP and camera drivers (update)
From: Arun KS <getarunks@gmail.com>
To: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	"ext Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	=?ISO-8859-1?Q?Koskip=E4=E4_Antti_Jussi_Petteri?=
	<antti.koskipaa@nokia.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Alexey Klimov <klimov.linux@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/3/9 DongSoo(Nathaniel) Kim <dongsoo.kim@gmail.com>:
> Hi Sakari,
>
> I've been trying to pull your gitorious patchset into my linux-omap
> repository (which is completely clean and up-to-date), but I'm having
> some problem.
> Please find following messages. I captured my git repository messages.
>
> kdsoo@chromatix:/home/share/GIT/OMAP_REF/kernel_org/linux-omap-2.6$ git pull
>
> Already up-to-date.
>
> kdsoo@chromatix:/home/share/GIT/OMAP_REF/kernel_org/linux-omap-2.6$ git status
>
> # On branch master
>
> nothing to commit (working directory clean)
>
> kdsoo@chromatix:/home/share/GIT/OMAP_REF/kernel_org/linux-omap-2.6$
> git pull http://git.gitorious.org/omap3camera/mainline.git v4l iommu
> omap3camera base
>
> error: Could not read 5b007183d51543624bc9f582966f245a64157b57
>
> error: Could not read fa8977215db5ab6139379e95efc193e45833afa3
>
> error: Could not read 7de046a6a8446358001c38ad1d0b2b829ca0c98c
>
> error: Could not read 5b007183d51543624bc9f582966f245a64157b57
>
> Unable to find common commit with dc05ee10583dca44e0f8d4109bd1397ee3c5ffae
>
> Automatic merge failed; fix conflicts and then commit the result.
>
>
>
>
> I guess other people should also have the same issue with it. or am I
> doing wrong way?
> Please let me know

Hi Nate,

I tried this git pull git://git.gitorious.org/omap3camera/mainline.git
v4l iommu omap3camera base
and it works for me.

Thanks,
Arun
>
>
> On Sat, Mar 7, 2009 at 12:32 AM, Sakari Ailus
> <sakari.ailus@maxwell.research.nokia.com> wrote:
>> Hi,
>>
>> I've updated the patchset in Gitorious.
>>
>> <URL:http://www.gitorious.org/projects/omap3camera>
>>
>> Changes include
>>
>> - Power management support. ISP suspend/resume should work now.
>>
>> - Reindented and cleaned up everything. There are still some warnings from
>> checkpatch.pl from the CSI2 code.
>>
>> - Fix for crash in device registration, posted to list already. (Thanks,
>> Vaibhav, Alexey!)
>>
>> - LSC errors should be handled properly now.
>>
>> I won't post the modified patches to the list this time since I guess it
>> wouldn't be much of use, I guess. Or does someone want that? :)
>>
>> --
>> Sakari Ailus
>> sakari.ailus@maxwell.research.nokia.com
>>
>
>
>
> --
> ========================================================
> DongSoo(Nathaniel), Kim
> Engineer
> Mobile S/W Platform Lab. S/W Team.
> DMC
> Samsung Electronics CO., LTD.
> e-mail : dongsoo.kim@gmail.com
>          dongsoo45.kim@samsung.com
> ========================================================
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
