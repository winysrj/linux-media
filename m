Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34806 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752191AbcEMI2O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 04:28:14 -0400
Subject: Re: [PATCH v4 1/8] v4l: subdev: Add pad config allocator and init
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1462975376-491-2-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk,
	Laurent Pinchart <laurent.pinchart@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57359017.7080706@xs4all.nl>
Date: Fri, 13 May 2016 10:28:07 +0200
MIME-Version: 1.0
In-Reply-To: <1462975376-491-2-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2016 04:02 PM, Ulrich Hecht wrote:
> From: Laurent Pinchart <laurent.pinchart@linaro.org>
> 
> Add a new subdev operation to initialize a subdev pad config array, and
> a helper function to allocate and initialize the array. This can be used
> by bridge drivers to implement try format based on subdev pad
> operations.

This patch has already been merged and can be dropped.

	Hans
