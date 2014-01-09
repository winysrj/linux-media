Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43366 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbaAIXOs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 18:14:48 -0500
Received: by mail-oa0-f50.google.com with SMTP id l6so4260977oag.9
        for <linux-media@vger.kernel.org>; Thu, 09 Jan 2014 15:14:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5728278.SyrhtX3J9t@avalon>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
	<CA+2YH7srzQcabeQyPd5TCuKcYaSmPd3THGh3uJE9eLjqKSJHKw@mail.gmail.com>
	<CA+2YH7sHg-D9hrTOZ5h03YcAaywZz5tme5omguxPtHdyCb5A4A@mail.gmail.com>
	<5728278.SyrhtX3J9t@avalon>
Date: Fri, 10 Jan 2014 00:14:47 +0100
Message-ID: <CA+2YH7tSJWgduXoCV5-qhSxrfPmcb5FfPGvHQAL=2xp+RQgxUQ@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: Enrico <ebutera@users.berlios.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 7, 2014 at 5:59 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Enrico,
>
> On Friday 03 January 2014 12:30:33 Enrico wrote:
>> On Wed, Dec 18, 2013 at 11:09 AM, Enrico wrote:
>> > On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard wrote:
>> >> So I converted the iommu to DT (patches just sent),
>
> Florian, I've used your patches as a base for OMAP3 ISP DT work and they seem
> pretty good (although patch 1/7 will need to be reworked, but that's not a
> blocker). I've just had to fix a problem with the OMAP3 IOMMU, please see
>
> http://git.linuxtv.org/pinchartl/media.git/commit/d3abafde0277f168df0b2912b5d84550590d80b2
>
> I'd appreciate your comments on that. I can post the patch already if you
> think that would be helpful.
>
> You can find my work-in-progress branch at
>
> http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp/dt
>
> (the last three patches are definitely not complete yet).
>
>> >> used pdata quirks for the isp / mtv9032 data, added a few patches from
>> >> other people (mainly clk to fix a crash when deferring the omap3isp
>> >> probe), and a few small hacks. I get a 3.13-rc3 (+ board-removal part
>> >> from Tony Lindgren) to boot on DT with a working MT9V032 camera. The
>> >> missing part is the DT binding for the omap3isp, but I guess that we will
>> >> have to wait a bit more for this.
>> >>
>> >> If you want to test, I have a development tree here [1]. Any feedback is
>> >> welcome.
>> >>
>> >> Cheers,
>> >>
>> >> Florian
>> >>
>> >> [1] https://github.com/vaussard/linux/commits/overo-for-3.14/iommu/dt
>> >
>> > Thanks Florian,
>> >
>> > i will report what i get with my setup.
>>
>> And here i am.
>>
>> I can confirm it works, video source is tvp5150 (with platform data in
>> pdata-quirks.c) in bt656 mode.
>>
>> Laurent, i used the two bt656 patches from your omap3isp/bt656 tree so
>> if you want to push it you can add a Tested-by me.
>
> The second patch is not clean enough in my opinion. I need to find time to
> work on it. I had set some time aside for OMAP3 ISP development last week but
> I've ended up working on DT support (not done yet, I've worked with Sakari and
> he might finish the job in the upcoming weeks) instead of BT.656. I'm afraid
> this will have to wait for around three weeks.

Yes i know the history of those patches, and if i'm not wrong you
didn't have the hardware to test them so i just wanted to confirm that
they work (apart from the other problem).

Enrico
