Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58659
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752633AbdDKIyW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 04:54:22 -0400
Date: Tue, 11 Apr 2017 05:54:13 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linuxtv-commits@linuxtv.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [git:media_tree/master] [media] ARM: dts: exynos: add HDMI
 controller phandle to exynos4.dtsi
Message-ID: <20170411055413.07957d91@vento.lan>
In-Reply-To: <CAJKOXPfbJpFu6r9rS8oCqxTH+s7y2wYKx9+TzGrv4Cd8DYaKew@mail.gmail.com>
References: <E1cxc0o-0003RE-PP@www.linuxtv.org>
        <CAJKOXPfbJpFu6r9rS8oCqxTH+s7y2wYKx9+TzGrv4Cd8DYaKew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Apr 2017 10:36:58 +0200
Krzysztof Kozlowski <krzk@kernel.org> escreveu:

> On Mon, Apr 10, 2017 at 6:12 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > This is an automatic generated email to let you know that the following patch were queued:
> >
> > Subject: [media] ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
> > Author:  Hans Verkuil <hans.verkuil@cisco.com>
> > Date:    Tue Dec 13 12:37:16 2016 -0200
> >
> > Add the new hdmi phandle to exynos4.dtsi. This phandle is needed by the
> > s5p-cec driver to initialize the CEC notifier framework.
> >
> > Tested with my Odroid U3.
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > CC: linux-samsung-soc@vger.kernel.org
> > CC: devicetree@vger.kernel.org
> > CC: Krzysztof Kozlowski <krzk@kernel.org>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >
> >  arch/arm/boot/dts/exynos4.dtsi | 1 +
> >  1 file changed, 1 insertion(+)
> >  
> 
> Mauro, you should not apply it. It is already going through samsung-soc [1].
> if you need this patch for bisectability or any other reasons, I
> provided a tag with it here:
> https://www.spinics.net/lists/devicetree/msg171182.html
> 
> Please drop the patch because now it will get duplicated.

Having exactly the same patch applied on multiple trees usually is
not a problem, provided that it doesn't rise a non-trivial
conflict.

I avoid rebase the tree where this patch is applied, as rebasing it
affect the workflow of other developers.

I'm afraid that, if I revert this patch, it will cause more harm than
good. 

So, I guess the best solution to fix the issue would be to pull from 
a stable branch on your tree with has this patch and solve conflicts,
if any. This way, nothing will popup when merging upstream.

Regards,
Mauro

> 
> Best regards,
> Krzysztof
> 
> [1] https://www.spinics.net/lists/arm-kernel/msg575229.html



Thanks,
Mauro
