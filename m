Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:59366 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388249AbeGXM2u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jul 2018 08:28:50 -0400
Subject: Re: [PATCH v3 00/35] Qualcomm Camera Subsystem driver - 8x96 support
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d548ed20-23ac-0ef9-9cbe-67da42cde19a@xs4all.nl>
Date: Tue, 24 Jul 2018 13:22:45 +0200
MIME-Version: 1.0
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On 23/07/18 13:02, Todor Tomov wrote:
> Changelog v3:
> - split patch 08 to device tree binding patch and driver patch and
>   improve commit message.
> 
> --------------------------------------------------------------------------------
> 
> This patchset adds support for the Qualcomm Camera Subsystem found
> on Qualcomm MSM8996 and APQ8096 SoC to the existing driver which
> used to support MSM8916 and APQ8016.
> 
> The camera subsystem hardware on 8x96 is similar to 8x16 but
> supports more cameras and features. More details are added in the
> driver document by the last patch.
> 
> The first 3 patches are dependencies which have already been on
> the mainling list but I'm adding them here for completeness.
> 
> The following 12 patches add general updates and fixes to the driver.
> Then the rest add the support for the new hardware.
> 
> The driver is tested on Dragonboard 410c (APQ8016) and Dragonboard 820c
> (APQ8096) with OV5645 camera sensors. media-ctl [1], yavta [2] and
> GStreamer were used for testing.
> 
> [1] https://git.linuxtv.org//v4l-utils.git
> [2] http://git.ideasonboard.org/yavta.git

Unless I am mistaken the only thing we're waiting for is an Ack from Rob for
patch 8 (dt bindings), right?

If I get that this week, then I can make a pull request in time for 4.19.

Regards,

	Hans
