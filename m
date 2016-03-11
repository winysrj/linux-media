Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35904 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbcCKOz7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 09:55:59 -0500
Received: by mail-ig0-f172.google.com with SMTP id vs8so12085033igb.1
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2016 06:55:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56E2C206.6020103@samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
	<1457122813-12791-3-git-send-email-javier@osg.samsung.com>
	<56E2C206.6020103@samsung.com>
Date: Fri, 11 Mar 2016 11:55:58 -0300
Message-ID: <CABxcv=nteCTgaN9t33vOovXoHarMXf_knxjTUfV+G36iQs8AGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] [media] exynos4-is: FIMC port parse should fail if
 there's no endpoint
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester,

On Fri, Mar 11, 2016 at 10:03 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 03/04/2016 09:20 PM, Javier Martinez Canillas wrote:
>> The fimc_md_parse_port_node() function return 0 if an endpoint node is
>> not found but according to Documentation/devicetree/bindings/graph.txt,
>> a port must always have at least one enpoint.
>>
>> So return an -EINVAL errno code to the caller instead, so it knows that
>> the port node parse failed due an invalid Device Tree description.
>
> I don't think it is forbidden to have a port node in device tree
> containing no endpoint nodes. Empty port node means only that,
> for example, a subsystem has a port/bus for connecting external
> devices but nothing is actually connected to it.
>

That's not what I understood by reading both
Documentation/devicetree/bindings/media/video-interfaces.txt and
Documentation/devicetree/bindings/graph.txt but maybe these are not
that clear about it or I just failed to parse the english.

> In case of Exynos CSIS it might not be so useful to have an empty
> port node specified in some top level *.dtsi file and only
> the endpoints specified in a board specific dts file. Nevertheless,
> I wouldn't be saying in general a port node must always have some
> endpoint node defined.
>

Ok, but if that is valid then I believe that at the very least
Documentation/devicetree/bindings/media/samsung-fimc.txt should
explicitly mention which (sub)nodes are optional and which are
required so the DT parsing logic could follow what's documented there.

> I could apply this patch as it doesn't do any harm considering
> existing dts files in the kernel tree (arch/arm/boot/dts/
> exynos4412-trats2.dts), but the commit description would need to
> be changed.
>

I don't mind if you want to change the commit message but if those
nodes are really optional then a follow-up should be to update the DT
binding docs to make that clear IMHO.

> --
> Thanks,
> Sylwester
> --

Best regards,
Javier
