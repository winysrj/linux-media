Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52646 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab2LQI5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 03:57:00 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so6677968vby.19
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 00:56:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uHaQ+5Yy1PDy+DE=iVN5ps6gmvSiWezapF=Kv338tZj0w@mail.gmail.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com> <CAKMK7uHaQ+5Yy1PDy+DE=iVN5ps6gmvSiWezapF=Kv338tZj0w@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 17 Dec 2012 14:26:39 +0530
Message-ID: <CAO_48GGxe5ZSeKsWO7=E-FoHXFVT7AOjwdAHv-oQk6F3qCXsOw@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Add debugfs support
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@ti.com>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14 December 2012 16:04, Daniel Vetter <daniel@ffwll.ch> wrote:
>
> Missed one ...
>
> On Fri, Dec 14, 2012 at 10:36 AM,  <sumit.semwal@ti.com> wrote:
> > +               list_for_each_entry(attach_obj, &buf_obj->attachments, node) {
> > +                       seq_printf(s, "\t\t");
> > +
> > +                       seq_printf(s, "%s\n", attach_obj->dev->init_name);
> > +                       attach_count++;
> > +               }
>
> You need to hold dmabuf->lock while walking the attachment list.
> -Daniel


Thanks Daniel!

Will update in next version.
>
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch



Best regards,

Sumit Semwal
