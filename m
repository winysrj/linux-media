Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:45399 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdFTNcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 09:32:41 -0400
Subject: Re: [PATCH 2/2] media/uapi/v4l: clarify cropcap/crop/selection
 behavior
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <9c1e4f38-3d66-b087-5f99-fa6821908705@samsung.com>
Date: Tue, 20 Jun 2017 15:32:30 +0200
MIME-version: 1.0
In-reply-to: <20170619134910.10138-3-hverkuil@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <20170619134910.10138-1-hverkuil@xs4all.nl>
        <CGME20170619134939epcas4p302a3cc55e8a46c3e61efa407622d14bd@epcas4p3.samsung.com>
        <20170619134910.10138-3-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/19/2017 03:49 PM, Hans Verkuil wrote:
> From: Hans Verkuil<hans.verkuil@cisco.com>
> 
> Unfortunately the use of 'type' was inconsistent for multiplanar
> buffer types. Starting with 4.14 both the normal and _MPLANE variants
> are allowed, thus making it possible to write sensible code.
> 
> Yes, we messed up:-(
> 
> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Thanks,
Sylwester
