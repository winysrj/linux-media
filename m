Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754161AbdDKJCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 05:02:15 -0400
MIME-Version: 1.0
In-Reply-To: <20170411055413.07957d91@vento.lan>
References: <E1cxc0o-0003RE-PP@www.linuxtv.org> <CAJKOXPfbJpFu6r9rS8oCqxTH+s7y2wYKx9+TzGrv4Cd8DYaKew@mail.gmail.com>
 <20170411055413.07957d91@vento.lan>
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Tue, 11 Apr 2017 11:02:09 +0200
Message-ID: <CAJKOXPe7fKz=ivoW3BTdk0TqANwJaZWMamQsKSXFRS4b4ywG9w@mail.gmail.com>
Subject: Re: [git:media_tree/master] [media] ARM: dts: exynos: add HDMI
 controller phandle to exynos4.dtsi
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linuxtv-commits@linuxtv.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 11, 2017 at 10:54 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Em Tue, 11 Apr 2017 10:36:58 +0200
> Krzysztof Kozlowski <krzk@kernel.org> escreveu:
>
>> On Mon, Apr 10, 2017 at 6:12 PM, Mauro Carvalho Chehab
>> <mchehab@s-opensource.com> wrote:
>> > This is an automatic generated email to let you know that the following patch were queued:
>> >
>> > Subject: [media] ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
>> > Author:  Hans Verkuil <hans.verkuil@cisco.com>
>> > Date:    Tue Dec 13 12:37:16 2016 -0200
>> >
>> > Add the new hdmi phandle to exynos4.dtsi. This phandle is needed by the
>> > s5p-cec driver to initialize the CEC notifier framework.
>> >
>> > Tested with my Odroid U3.
>> >
>> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> > CC: linux-samsung-soc@vger.kernel.org
>> > CC: devicetree@vger.kernel.org
>> > CC: Krzysztof Kozlowski <krzk@kernel.org>
>> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> >
>> >  arch/arm/boot/dts/exynos4.dtsi | 1 +
>> >  1 file changed, 1 insertion(+)
>> >
>>
>> Mauro, you should not apply it. It is already going through samsung-soc [1].
>> if you need this patch for bisectability or any other reasons, I
>> provided a tag with it here:
>> https://www.spinics.net/lists/devicetree/msg171182.html
>>
>> Please drop the patch because now it will get duplicated.
>
> Having exactly the same patch applied on multiple trees usually is
> not a problem, provided that it doesn't rise a non-trivial
> conflict.
>
> I avoid rebase the tree where this patch is applied, as rebasing it
> affect the workflow of other developers.
>
> I'm afraid that, if I revert this patch, it will cause more harm than
> good.

Of course, revert is wrong. The patch should be dropped with rebase,
assuming that you accept the rebase itself. But if you do not
rebase... then it has to  stay.

> So, I guess the best solution to fix the issue would be to pull from
> a stable branch on your tree with has this patch and solve conflicts,
> if any. This way, nothing will popup when merging upstream.

This is why I provided it in separate tag, in first place!
That is a proper solution for avoiding any patch duplication and
conflicts. Indeed you are right that duplication of commits should not
do any harm... but it is not a proper way of development, right?

Anyway, it is up to you. I provided you a tag with it so you can merge
it if needed (which would require rebasing). If not, then of course
please do not revert it.

Best regards,
Krzysztof
