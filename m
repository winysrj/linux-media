Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53481 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdGVGw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 22 Jul 2017 02:52:58 -0400
Subject: Re: [PATCHv2 5/5] media-device: remove driver_version
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <a6221283-0928-38ba-31bf-de6e6ff6fbdf@samsung.com>
Date: Sat, 22 Jul 2017 08:52:52 +0200
MIME-version: 1.0
In-reply-to: <20170721105706.40703-6-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170721105706.40703-1-hverkuil@xs4all.nl>
        <20170721105706.40703-6-hverkuil@xs4all.nl>
        <CGME20170722065256epcas5p46009c853615835492c5ed35ec9fe7bf4@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2017 12:57 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Since the driver_version field in struct media_device is no longer
> used, just remove it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
