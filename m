Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC966C282C2
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 723EA2175B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfBFKq1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:46:27 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51361 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728574AbfBFKq0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 05:46:26 -0500
Received: from [IPv6:2001:983:e9a7:1:d87d:799b:abeb:e52d] ([IPv6:2001:983:e9a7:1:d87d:799b:abeb:e52d])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rKijgeHiCNR5yrKikguOvX; Wed, 06 Feb 2019 11:46:25 +0100
Subject: Re: [PATCH] media: v4l2-tpg: Fix the memory layout of AYUV buffers
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-media@vger.kernel.org
References: <20190129023222.10036-1-vivek.kasireddy@intel.com>
 <92dbd1f9-f5dc-37ed-856a-b3b2aa2b75d5@xs4all.nl>
 <1549377502.3929.12.camel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c7aaec9c-2660-1d60-5bab-704b812ea01c@xs4all.nl>
Date:   Wed, 6 Feb 2019 11:46:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1549377502.3929.12.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBG13iFimxxm1rvnShH+XAettkfOYswk7e6nyZv9OjD4e+CpDiBe8O9XD7IkTdnvVyd4QMxesGhjt2Up5JkOsLIYEXJCN0hn3VxIXiYPsiI9Z6+KxYEG
 MPCgFnwGcQ7NEvKhRS3tgUyRMp19tuOQdhfJs9RTFJivhmeKUXtKOcxq/jaMfyTOtvSrwlhFkIo3Hxd1CUPRiLbLHO30hoWrQV4TZl0FfIW2UohIskd4Jhai
 TMFCMO2uWG6cpZ138udBE+tINaYkKB0MPCN/e72cwUBOaQTvzfDyky3M01yEYAuQR53LK7m/bhS/9H59g4X0jZnwHrybATaFwZfNFg2WhYaRmnEulEqLRO3u
 KUwrilbJ
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/5/19 3:38 PM, Philipp Zabel wrote:
> Hi Hans,
> 
> On Thu, 2019-01-31 at 14:36 +0100, Hans Verkuil wrote:
> [...]
>>
>> Our YUV32 fourcc is defined as follows:
>>
>> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/pixfmt-packed-yuv.html
>>
>> As far as I see the format that the TPG generates is according to the V4L2 spec.
>>
>> Philipp, can you check the YUV32 format that the imx-pxp driver uses?
>> Is that according to our spec?
>>
>> At some point we probably want to add a VUY32 format which is what Weston
>> expects, but we certainly cannot change what the TPG generates for YUV32
>> since that is correct.
> 
> I hadn't noticed as YUV32 doesn't show up in GStreamer, but testing with
> v4l2-ctl, it seems to be incorrect. This script:
> 
>   #!/bin/sh
>   function check() {
>       PATTERN="$1"
>       NAME="$2"
>       echo -ne "${NAME}:\t"
>       v4l2-ctl \
>           --set-fmt-video-out=width=8,height=8,pixelformat=RGBP \
>           --set-fmt-video=width=8,height=8,pixelformat=YUV4 \
>           --stream-count 1 \
>           --stream-poll \
>           --stream-out-pattern "${PATTERN}" \
>           --stream-out-mmap 3 \
>           --stream-mmap 3 \
>           --stream-to - 2>/dev/null | hexdump -v -n4 -e '/1 "%02x "'
>       echo
>   }
>   check 6 "100% white"
>   check 7 "100% red"
>   check 9 "100% blue"
> 
> results in the following output:
> 
>   100% white:	80 80 ea ff 
>   100% red:	f0 66 3e ff 
>   100% blue:	74 f0 23 ff 
> 
> That looks like 32-bit VUYA 8-8-8-8.

Right. So Vivek, can you make the patches to add a proper VUYA pixelformat?

And a final patch updating imx-pxp so it uses the right pixelformat?

Since there is now a driver using it, it is also not a problem anymore to
get the new pixelformat patches merged.

Regards,

	Hans
