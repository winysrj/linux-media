Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:38367 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755148AbcLOKqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 05:46:11 -0500
Subject: Re: [PATCH] media: platform: s3c-camif: constify v4l2_subdev_ops
 structures
To: Bhumika Goyal <bhumirks@gmail.com>, linux-media@vger.kernel.org
References: <CGME20161214111230epcas2p3c17ddece4633cdd49ee7759b8215da23@epcas2p3.samsung.com>
 <1481713870-7513-1-git-send-email-bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <91f5f6ee-d5b0-ff6b-a254-dfcc5f6d6fb1@samsung.com>
Date: Thu, 15 Dec 2016 11:34:38 +0100
MIME-version: 1.0
In-reply-to: <1481713870-7513-1-git-send-email-bhumirks@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/14/2016 12:11 PM, Bhumika Goyal wrote:
> Check for v4l2_subdev_ops structures that are only passed as an
> argument to the function v4l2_subdev_init. This argument is of type
> const, so v4l2_subdev_ops structures having this property can also  be
> declared const.

> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
