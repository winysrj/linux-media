Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA06C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FDAA2082F
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 13:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbfAPN7s (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 08:59:48 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:56429 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727935AbfAPN7s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 08:59:48 -0500
Received: from [IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427] ([IPv6:2001:983:e9a7:1:74b9:e8d0:a90b:6427])
        by smtp-cloud8.xs4all.net with ESMTPA
        id jljMgU9YHNR5yjljNgPafU; Wed, 16 Jan 2019 14:59:45 +0100
Subject: Re: [PATCH 1/1] v4l: ioctl: Validate num_planes for debug messages
To:     Sasha Levin <sashal@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>, stable@vger.kernel.org
References: <20190110142426.1124-1-sakari.ailus@linux.intel.com>
 <20190116133554.E22672086D@mail.kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a90f66d7-01e8-9269-2f85-d4d159340910@xs4all.nl>
Date:   Wed, 16 Jan 2019 14:59:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190116133554.E22672086D@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNTNe+gVd56ey4Rbqbb5v1PhrfPHJwx9qX/Ibj7KY9NpOQ4Qxmp0/VBy/dTjCTbXo4Lli3yJKEWxGkx+FzpDLRUCJLfGQodcvqUxzpU0P1IRZDl82Swj
 8JXs5dFDAUSFIoJ90viTizg/Tmfz9LjSPiaiN8JpsqX2ANMVGN5SicMVsiYAJpSrOpH7l/T7nIB4pXEa0w4na0rwQXECk6mR60+EiCmLXXVPE36PM1YgS2/h
 cQAjKdCTQxIwqd0K0IcXCNkFJRCbU8+u/vdC/5XplCmVWVeXPSVMuAeWsYr07I+alLcg5UEVMq5VNNCjBoU5e8MMYdVTto0RQDtFesNM8crOsDWGN0M28keV
 2TS/qWLjmRZcbHNPs4idqQrXKbw6QZOXd8fd5YbsNME37W+R27s0G8iOXizzWcjjGQqlgfGR
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/16/19 2:35 PM, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v4.20.2, v4.19.15, v4.14.93, v4.9.150, v4.4.170, v3.18.132.
> 
> v4.20.2: Build OK!
> v4.19.15: Build OK!
> v4.14.93: Build OK!
> v4.9.150: Failed to apply! Possible dependencies:
>     fb9ffa6a7f7e ("[media] v4l: Add metadata buffer type and format")
> 
> v4.4.170: Failed to apply! Possible dependencies:
>     0579e6e3a326 ("doc-rst: linux_tv: remove whitespaces")
>     17defc282fe6 ("Documentation: add meta-documentation for Sphinx and kernel-doc")
>     22cba31bae9d ("Documentation/sphinx: add basic working Sphinx configuration and build")
>     234d549662a7 ("doc-rst: video: use reference for VIDIOC_ENUMINPUT")
>     5377d91f3e88 ("doc-rst: linux_tv DocBook to reST migration (docs-next)")
>     7347081e8a52 ("doc-rst: linux_tv: simplify references")
>     789818845202 ("doc-rst: audio: Fix some cross references")
>     94fff0dc5333 ("doc-rst: dmx_fcalls: improve man-like format")
>     9e00ffca8cc7 ("doc-rst: querycap: fix troubles on some references")
>     af4a4d0db8ab ("doc-rst: linux_tv: Replace reference names to match ioctls")
>     c2b66cafdf02 ("[media] v4l: doc: Remove row numbers from tables")
>     e6702ee18e24 ("doc-rst: app-pri: Fix a bad reference")
>     fb9ffa6a7f7e ("[media] v4l: Add metadata buffer type and format")
> 
> v3.18.132: Failed to apply! Possible dependencies:
>     0579e6e3a326 ("doc-rst: linux_tv: remove whitespaces")
>     17defc282fe6 ("Documentation: add meta-documentation for Sphinx and kernel-doc")
>     22cba31bae9d ("Documentation/sphinx: add basic working Sphinx configuration and build")
>     5377d91f3e88 ("doc-rst: linux_tv DocBook to reST migration (docs-next)")
>     5699f871d2d5 ("scripts/kernel-doc: Adding cross-reference links to html documentation.")
>     7347081e8a52 ("doc-rst: linux_tv: simplify references")
>     af4a4d0db8ab ("doc-rst: linux_tv: Replace reference names to match ioctls")
>     b479bfd00e46 ("DocBook: Use a fixed encoding for output")
>     c2b66cafdf02 ("[media] v4l: doc: Remove row numbers from tables")
>     e6702ee18e24 ("doc-rst: app-pri: Fix a bad reference")
>     fb9ffa6a7f7e ("[media] v4l: Add metadata buffer type and format")
> 
> 
> How should we proceed with this patch?

The Cc to stable of this patch in the pending pull request has a 'for v4.12 and up':

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=for-v5.0a&id=8015f0ce4a3c533acfbb3a71f0d6659fa4120778

So no need to patch pre-4.12 kernels.

Regards,

	Hans
