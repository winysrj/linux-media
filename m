Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:17173 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbdDKIjL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Apr 2017 04:39:11 -0400
Subject: Re: [git:media_tree/master] [media] ARM: dts: exynos: add HDMI
 controller phandle to exynos4.dtsi
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <E1cxc0o-0003RE-PP@www.linuxtv.org>
 <CAJKOXPfbJpFu6r9rS8oCqxTH+s7y2wYKx9+TzGrv4Cd8DYaKew@mail.gmail.com>
Cc: linuxtv-commits@linuxtv.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <0c8fef60-a99d-c5ed-67e4-3769105fa211@cisco.com>
Date: Tue, 11 Apr 2017 10:39:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJKOXPfbJpFu6r9rS8oCqxTH+s7y2wYKx9+TzGrv4Cd8DYaKew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/17 10:36, Krzysztof Kozlowski wrote:
> On Mon, Apr 10, 2017 at 6:12 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
>> This is an automatic generated email to let you know that the following patch were queued:
>>
>> Subject: [media] ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
>> Author:  Hans Verkuil <hans.verkuil@cisco.com>
>> Date:    Tue Dec 13 12:37:16 2016 -0200
>>
>> Add the new hdmi phandle to exynos4.dtsi. This phandle is needed by the
>> s5p-cec driver to initialize the CEC notifier framework.
>>
>> Tested with my Odroid U3.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> CC: linux-samsung-soc@vger.kernel.org
>> CC: devicetree@vger.kernel.org
>> CC: Krzysztof Kozlowski <krzk@kernel.org>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>>
>>  arch/arm/boot/dts/exynos4.dtsi | 1 +
>>  1 file changed, 1 insertion(+)
>>
> 
> Mauro, you should not apply it. It is already going through samsung-soc [1].
> if you need this patch for bisectability or any other reasons, I
> provided a tag with it here:
> https://www.spinics.net/lists/devicetree/msg171182.html
> 
> Please drop the patch because now it will get duplicated.

I apologize for that. I realized that I shouldn't have included this in
my pull request when it was already merged.

My fault completely.

Regards,

	Hans
