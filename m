Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:43055 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbbGGH7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2015 03:59:31 -0400
Message-ID: <1436255963.20057.106.camel@tiscali.nl>
Subject: Re: [PATCH v2 1/2] create SMAF module
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: tom.gall@linaro.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com
Date: Tue, 07 Jul 2015 09:59:23 +0200
In-Reply-To: <1436182827-6218-2-git-send-email-benjamin.gaignard@linaro.org>
References: <1436182827-6218-1-git-send-email-benjamin.gaignard@linaro.org>
	 <1436182827-6218-2-git-send-email-benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A nit only, I'm afraid: a license mismatch.

On ma, 2015-07-06 at 13:40 +0200, Benjamin Gaignard wrote:
> --- /dev/null
> +++ b/drivers/smaf/smaf-core.c

> + * License terms:  GNU General Public License (GPL), version 2

> +MODULE_LICENSE("GPL");

The comment at the top of this file states, succinctly, that the license
is GPL v2. And, according to include/linux/module.h, the
MODULE_LICENSE() macro here states that the license is GPL v2 or later.
So I think that either that comment or the ident used in that macro
needs to change.

Ditto for 2/2.

Thanks,


Paul Bolle
