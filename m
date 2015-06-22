Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50925 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933048AbbFVHbs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 03:31:48 -0400
Message-ID: <5587B9C9.70803@xs4all.nl>
Date: Mon, 22 Jun 2015 09:31:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Benoit Parrot <bparrot@ti.com>
CC: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch 0/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture driver
References: <1434475763-20294-1-git-send-email-bparrot@ti.com>
In-Reply-To: <1434475763-20294-1-git-send-email-bparrot@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2015 07:29 PM, Benoit Parrot wrote:
> The Camera Adaptation Layer (CAL) is a block which consists of a dual
> port CSI2/MIPI camera capture engine.
> This camera engine is currently found on DRA72xx family of devices.
> 
> Port #0 can handle CSI2 camera connected to up to 4 data lanes.
> Port #1 can handle CSI2 camera connected to up to 2 data lanes.
> 
> The driver implements the required API/ioctls to be V4L2 compliant.
> Driver supports the following:
>     - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
>     - Asynchronous sensor sub device registration
>     - DT support
> 
> Currently each port is designed to connect to a single sub-device.
> In other words port aggregation is not currently supported.
> 
> Here is a sample output of the v4l2-compliance tool:
> 
> # ./v4l2-compliance -s -v -d /dev/video0

Can you show the output of './v4l2-compliance -f' as well?

Thanks!

	Hans

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
