Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35693 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753309Ab3LCNYB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 08:24:01 -0500
Date: Tue, 3 Dec 2013 15:23:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, lxr1234@hotmail.com,
	jtp.park@samsung.com, m.chehab@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH] media: v4l2-dev: fix video device index assignment
Message-ID: <20131203132355.GB30652@valkosipuli.retiisi.org.uk>
References: <1386076469-26761-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386076469-26761-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Marek!

Thanks for the patch.

On Tue, Dec 03, 2013 at 02:14:29PM +0100, Marek Szyprowski wrote:
> The side effect of commit 1056e4388b045 ("v4l2-dev: Fix race condition on
> __video_register_device") is the increased number of index value assigned
> on video_device registration. Before that commit video_devices were
> numbered from 0, after it, the indexes starts from 1, because get_index()
> always count the device, which is being registered. Some device drivers
> rely on video_device index number for internal purposes, i.e. s5p-mfc
> driver stopped working after that patch. This patch restores the old method
> of numbering the video_device indexes.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
> In my opinion this patch should be applied also to stable v3.12 series.

I agree.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
