Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44322 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2CPRxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 13:53:15 -0400
Received: by iagz16 with SMTP id z16so5713421iag.19
        for <linux-media@vger.kernel.org>; Fri, 16 Mar 2012 10:53:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
References: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
Date: Fri, 16 Mar 2012 17:53:15 +0000
Message-ID: <CAPM=9txFA1M4CK2njLDJRwLn6ZaPQMUsiqMCybqLSwWmZ7Y=mw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add get_dma_buf()
From: Dave Airlie <airlied@gmail.com>
To: Rob Clark <rob.clark@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, airlied@redhat.com, daniel@ffwll.ch,
	patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2012 at 4:04 PM, Rob Clark <rob.clark@linaro.org> wrote:
> From: Rob Clark <rob@ti.com>
>
> Works in a similar way to get_file(), and is needed in cases such as
> when the exporter needs to also keep a reference to the dmabuf (that
> is later released with a dma_buf_put()), and possibly other similar
> cases.
>
> Signed-off-by: Rob Clark <rob@ti.com>

Reviewed-by: Dave Airlie <airlied@redhat.com>
