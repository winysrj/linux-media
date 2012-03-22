Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58766 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab2CVGFZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 02:05:25 -0400
Received: by qcqw6 with SMTP id w6so1112375qcq.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 23:05:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332193370-27820-1-git-send-email-rob.clark@linaro.org>
References: <1332193370-27820-1-git-send-email-rob.clark@linaro.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 22 Mar 2012 11:35:04 +0530
Message-ID: <CAO_48GHgpr6RMbQHuS2gY3HZeQw5NJbpshgMBfwAemm8ACFQXQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: document fd flags and O_CLOEXEC requirement
To: Rob Clark <rob.clark@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	patches@linaro.org, daniel.vetter@ffwll.ch, Rob Clark <rob@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 March 2012 03:12, Rob Clark <rob.clark@linaro.org> wrote:
> From: Rob Clark <rob@ti.com>
>
> Otherwise subsystems will get this wrong and end up with a second
> export ioctl with the flag and O_CLOEXEC support added.
>
> Signed-off-by: Rob Clark <rob@ti.com>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
> Updated version of Daniel's original documentation patch with (hopefully)
> improved wording, and a better description of the motivation.
Thanks; applied this in place of Daniel's to for-next.
>
BR,
~Sumit.
