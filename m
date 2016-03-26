Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:58553 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751806AbcCZMu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 08:50:27 -0400
Message-ID: <1458996622.23450.4.camel@perches.com>
Subject: Re: [RFC PATCH 1/4] media: Add Media Device Allocator API
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuahkh@osg.samsung.com>,
	laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org
Date: Sat, 26 Mar 2016 05:50:22 -0700
In-Reply-To: <41d017ef76e3206780c018399ec60b63d865f65c.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
	 <41d017ef76e3206780c018399ec60b63d865f65c.1458966594.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-03-25 at 22:38 -0600, Shuah Khan wrote:
> Add Media Device Allocator API to manage Media Device life time problems.
> There are known problems with media device life time management. When media
> device is released while an media ioctl is in progress, ioctls fail with
> use-after-free errors and kernel hangs in some cases.

Seems reasonable, thanks.

trivial:

> diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
[]
> +static struct media_device *__media_device_get(struct device *dev,
> +					       bool alloc, bool kref)
> +{
[]
> +	pr_info("%s: mdev=%p\n", __func__, &mdi->mdev);

All of the pr_info uses here seem like debugging
and should likely be pr_debug instead.
> +struct media_device *media_device_find(struct device *dev)
> +{
> +	pr_info("%s\n", __func__);

These seem like function tracing and maybe could/should
use ftrace instead.
+/* don't allocate - increment kref if one is found */
> +struct media_device *media_device_get_ref(struct device *dev)
> +{
> +	pr_info("%s\n", __func__);

