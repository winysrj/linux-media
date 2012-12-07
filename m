Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47741 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2LGILf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2012 03:11:35 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so66416bkw.19
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2012 00:11:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAQKjZOomB2TkKtgZpS0DHM=vOzozWM-6AaztuWPMnxDXZx6Rg@mail.gmail.com>
References: <1354817271-5121-5-git-send-email-aplattner@nvidia.com>
	<1354819712-7019-1-git-send-email-aplattner@nvidia.com>
	<CAAQKjZOomB2TkKtgZpS0DHM=vOzozWM-6AaztuWPMnxDXZx6Rg@mail.gmail.com>
Date: Fri, 7 Dec 2012 09:11:33 +0100
Message-ID: <CAKMK7uHBNyicjxngsg3wGOZUOOB8OM1ev9hO7TbYCd+w6NKVcQ@mail.gmail.com>
Subject: Re: [PATCH v2] drm/exynos: use prime helpers
From: Daniel Vetter <daniel@ffwll.ch>
To: Inki Dae <inki.dae@samsung.com>
Cc: Aaron Plattner <aplattner@nvidia.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 7, 2012 at 7:36 AM, Inki Dae <inki.dae@samsung.com> wrote:
> Thus, I'm not sure that your common set could cover all the cases including
> other frameworks. Please give me any opinions.

I don't think that's required - as long as it is fairly useable by
many drivers a helper library is good enough. And since it's no
midlayer there's no requirement to use it, you're always free to do
your own special sauce in your driver. But I think the current rfc
could be made a bit more flexible so that more drivers could use at
least parts of it, see my other mail.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
