Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46489 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750952AbdFSHyA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 03:54:00 -0400
Subject: Re: [PATCH v4 00/11] [media]: vimc: Virtual Media Control VPU's
To: Helen Koike <helen.koike@collabora.com>,
        linux-media@vger.kernel.org
Cc: jgebben@codeaurora.org, mchehab@osg.samsung.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1da45fde-5d5b-0746-0bcd-ac8638013151@xs4all.nl>
Date: Mon, 19 Jun 2017 09:53:53 +0200
MIME-Version: 1.0
In-Reply-To: <1497382545-16408-1-git-send-email-helen.koike@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On 06/13/2017 09:35 PM, Helen Koike wrote:
> This patch series improves the current video processing units in vimc
> (by adding more controls to the sensor and capture node, allowing the
> user to configure different frame formats) and also adds a debayer
> and a scaler node.
> The debayer transforms the bayer format image received in its sink pad
> to a bayer format by averaging the pixels within a mean window.
> The scaler only scales up the image for now.
> 
> This patch series is based on media/master and it is available at:
> 	https://github.com/helen-fornazier/opw-staging/tree/z/sent/vimc/vpu/v4
> 
> In this version I removed the commit
> 	[media] vimc: Optimize frame generation through the pipe
> There was a bug when multiple links going to the same sink was enabled,
> I'll rework on it and re-send it in a different patch series

I ran the v4 patch series through my sparse/smatch test and found a few warnings:

sparse:

drivers/media/platform/vimc/vimc-debayer.c:376:30: warning: symbol 'vimc_deb_video_ops' was not declared. Should it be static?
drivers/media/platform/vimc/vimc-scaler.c:270:30: warning: symbol 'vimc_sca_video_ops' was not declared. Should it be static?
drivers/media/platform/vimc/vimc-sensor.c:285:30: warning: symbol 'vimc_sen_video_ops' was not declared. Should it be static?

smatch:

drivers/media/platform/vimc/vimc-core.c:271 vimc_add_subdevs() warn: always true condition '(--i >= 0) => (0-u32max >= 0)'
drivers/media/platform/vimc/vimc-core.c:271 vimc_add_subdevs() warn: always true condition '(--i >= 0) => (0-u32max >= 0)'

Can you take a look?

Regards,

	Hans
