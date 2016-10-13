Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27166 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932331AbcJMOXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 10:23:37 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEZ00CXOP8TVS20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Oct 2016 15:22:05 +0100 (BST)
Subject: Re: [PATCH v4l-utils 7/7 v7.1] Add a libv4l plugin for Exynos4 camera
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <b7410bd3-4033-3fae-f879-cdec46da625d@samsung.com>
Date: Thu, 13 Oct 2016 16:22:02 +0200
MIME-version: 1.0
In-reply-to: <1476368363-18841-1-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <CGME20161013141953epcas1p279e6e44c3d998bffc12d79db52b4757a@epcas1p2.samsung.com>
 <1476368363-18841-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Forgot to add changelog:

Changes since v7:

- fixed and improved ctrl ioctl handlers

Best regards,
Jacek Anaszewski

On 10/13/2016 04:19 PM, Jacek Anaszewski wrote:
> The plugin provides support for the media device on Exynos4 SoC.
> It performs single plane <-> multi plane API conversion,
> video pipeline linking and takes care of automatic data format
> negotiation for the whole pipeline, after intercepting
> VIDIOC_S_FMT or VIDIOC_TRY_FMT ioctls.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
