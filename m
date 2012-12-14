Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37529 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab2LNKeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 05:34:08 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1605513bkw.19
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2012 02:34:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
Date: Fri, 14 Dec 2012 11:34:06 +0100
Message-ID: <CAKMK7uHaQ+5Yy1PDy+DE=iVN5ps6gmvSiWezapF=Kv338tZj0w@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Add debugfs support
From: Daniel Vetter <daniel@ffwll.ch>
To: sumit.semwal@ti.com
Cc: sumit.semwal@linaro.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Missed one ...

On Fri, Dec 14, 2012 at 10:36 AM,  <sumit.semwal@ti.com> wrote:
> +               list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
> +                       seq_printf(s, "\t\t");
> +
> +                       seq_printf(s, "%s\n", attach_obj->dev->init_name);
> +                       attach_count++;
> +               }

You need to hold dmabuf->lock while walking the attachment list.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
