Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:15644 "EHLO
	relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751814AbbLNB6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Dec 2015 20:58:42 -0500
Message-ID: <566E224D.7020206@rvc.renesas.com>
Date: Mon, 14 Dec 2015 08:58:37 +0700
From: Khiem Nguyen <khiem.nguyen.xt@rvc.renesas.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>,
	Toru Oishi <toru.oishi.zj@rvc.renesas.com>,
	Khiem Nguyen <khiem.nguyen.xt@rvc.renesas.com>
Subject: Re: [PATCH v2 00/32] VSP: Add R-Car Gen3 support
References: <1449281586-25726-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <3938053.0568U3PJkY@avalon> <566A8CAF.9080200@rvc.renesas.com> <53707193.Qr7t8enSnR@avalon>
In-Reply-To: <53707193.Qr7t8enSnR@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2015 1:53 AM, Laurent Pinchart wrote:
> Hello Khiem,
>
> On Friday 11 December 2015 15:43:27 Khiem Nguyen wrote:
>> On 12/6/2015 5:54 AM, Laurent Pinchart wrote:
>>> On Saturday 05 December 2015 11:57:49 Geert Uytterhoeven wrote:
>>>> On Sat, Dec 5, 2015 at 3:12 AM, Laurent Pinchart wrote:
>>>>> This patch set adds support for the Renesas R-Car Gen3 SoC family to the
>>>>> VSP1 driver. The large number of patches is caused by a change in the
>>>>> display controller architecture that makes usage of the VSP mandatory as
>>>>> the display controller has lost the ability to read data from memory.
>>>>>
>>>>> Patch 01/32 to 27/32 prepare for the implementation of an API exported
>>>>> to the DRM driver in patch 28/32. Patches 31/32 enables support for the
>>>>> R-Car Gen3 family, and patch 32/32 finally enhances perfomances by
>>>>> implementing support for display lists.
>>>>>
>>>>> The major change compared to v1 is the usage of the IP version register
>>>>> instead of DT properties to configure device parameters such as the
>>>>> number of BRU inputs or the availability of the BRU.
>>>>
>>>> Thanks for your series!
>>>>
>>>> As http://git.linuxtv.org/pinchartl/media.git/tag/?id=vsp1-kms-20151112
>>>> is getting old, and has lots of conflicts with recent -next, do you plan
>>>> to publish this in a branch, and a separate branch for integration, to
>>>> ease integration in renesas-drivers?
>>>>
>>>> Alternatively, I can just import the series you posted, but having the
>>>> broken-out integration part would be nice.
>>>
>>> The issue I'm facing is that there's more than just two series. Beside the
>>> base VSP patches from this series, I have a series of DRM patches that
>>> depend on this one, a series of V4L2 core patches, another series of VSP
>>> patches that I still need to finish and a bunch of integration patches.
>>> As some of these have dependencies on H3 CCF support that hasn't landed
>>> in Simon's tree yet, I have merged your topic/cpg-mssr-v6 and
>>> topic/r8a7795-drivers-sh-v1 branches into my tree for development.
>>>
>>> I could keep all series in separate branches and merge the two topic
>>> branches last, but that's not very handy during development when I have
>>> to continuously rebase my patches. Is there a way I could handle this
>>> that would make your life easier while not making mine more difficult ?
>>>
>>> In the meantime I've pushed vsp1-kms-20151206 to
>>> git://linuxtv.org/pinchartl/media.git.
>>
>> I failed to confirm DU (VGA port) with above branch.
>>
>> To make DU (VGA port) work,
>> it seems I need to merge more branches like topic/cpg-mssr-v6
>> and topic/r8a7795-drivers-sh-v1 branches from renesas-drivers repo, is
>> it correct ?
>
> The
>
> 	git://linuxtv.org/pinchartl/media.git vsp1-kms-20151206
>
> branch already contains topic/r8a7795-drivers-sh-v1 and topic/cpg-mssr-v6.
> What is the failure you're seeing ?
>

Honestly, I tried some configurations but there's no output to VGA port 
(the display is blank).
1. The default 'defconfig' of this tag.
2. Enable DRM, CMA, RCAR_DU
3. Enable DRM, CMA, RCAR_DU, VSP1
      -> I got kernel build error in file 
drivers/media/platform/vsp1/vsp1_pipe.c

I also tried another tag vsp1-kms-request-20151206 which have more 
patches on top of vsp1-kms-20151206.
After enabling all DRM, CMA, RCAR_DU, VSP1, kernel build is OK.
Got a 'green color' display and no kernel log output.

With the same u-boot and IPL, it's able to see display output normally 
if using Gen3 BSP version.
Therefore, I guess it's no impact to DU operation.

Please let me know your procedure to test DU operation with your tag.

-- 
Best regards,
KHIEM Nguyen

