Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20D8C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B722177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 11:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730189AbfBRLjo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 06:39:44 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45372 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730246AbfBRLji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 06:39:38 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 35B3E634C7E;
        Mon, 18 Feb 2019 13:38:44 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gvhFz-0003gp-Vn; Mon, 18 Feb 2019 13:38:43 +0200
Date:   Mon, 18 Feb 2019 13:38:43 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        kernel@collabora.com
Subject: Re: [PATCH] media: v4l: ioctl: Sanitize num_planes before using it
Message-ID: <20190218113843.pwxkxnxhfy6j6p2d@valkosipuli.retiisi.org.uk>
References: <20190218102542.21776-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218102542.21776-1-ezequiel@collabora.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ezequiel,

On Mon, Feb 18, 2019 at 07:25:42AM -0300, Ezequiel Garcia wrote:
> The linked commit changed s_fmt/try_fmt to fail if num_planes is bogus.
> This, however, is against the spec, which mandates drivers
> to return a proper num_planes value, without an error.
> 
> Replace the num_planes check and instead clamp it to a sane value,
> so we still make sure we don't overflow the planes array by accident.
> 
> Fixes: 9048b2e15b11c5 ("media: v4l: ioctl: Validate num_planes before using it")
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>

Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
