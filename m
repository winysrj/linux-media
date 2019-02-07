Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C6DC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 12:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D6421721
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 12:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfBGM3r (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 07:29:47 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:39316 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726727AbfBGM3r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Feb 2019 07:29:47 -0500
Received: from [IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5] ([IPv6:2001:983:e9a7:1:38dd:c345:eb31:caf5])
        by smtp-cloud8.xs4all.net with ESMTPA
        id rioLgwOoaNR5yrioMg1Yns; Thu, 07 Feb 2019 13:29:46 +0100
Subject: Re: [PATCH 0/2] Remove more SoC camera sensor drivers
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ab6d189a-9c2b-c750-7c3a-bcfa9f31adab@xs4all.nl>
Date:   Thu, 7 Feb 2019 13:29:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPC9lsdkaaL+3eO/WGPDo8e3RTpJmrGc31xzd/BMhf/VBXwuoV1Ivkf2Vh1QhlChsynvsXPWqB8NNPXJPYecGeKd0CTx1Zv5UlI1NfRdPHqEYRC5Z5wU
 +DaMauymXEK3m2dllciY5chT4ieIPcpwn9pSzT8sJOiLOWzcprFLk3KQIiPV+vmpBW3sWmd3yMYdzlpWHVrFY8nj2JDhzroK9FC4TLlkfjVTPK1onQ6fW0UH
 wRVhUOsqPRnJ4CNYKcNJFik4UE3tivg0ndMTgtM/OFoIVnU3b2ep+Znyz/lpyuEMUd/S6+rcC+Swy8WH63aqhQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/4/19 4:42 PM, Sakari Ailus wrote:
> Hi folks,
> 
> This set removes two additional SoC camera sensor drivers that have
> corresponding V4L2 sub-device drivers.
> 
> Sakari Ailus (2):
>   soc_camera: Remove the mt9m001 SoC camera sensor driver
>   soc_camera: Remove the rj45n1 SoC camera sensor driver

For the series:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> 
>  drivers/media/i2c/soc_camera/Kconfig          |   13 -
>  drivers/media/i2c/soc_camera/Makefile         |    2 -
>  drivers/media/i2c/soc_camera/soc_mt9m001.c    |  757 -------------
>  drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c | 1415 -------------------------
>  4 files changed, 2187 deletions(-)
>  delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9m001.c
>  delete mode 100644 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
> 

