Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35162 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578AbcCSXzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 19:55:17 -0400
Received: by mail-io0-f177.google.com with SMTP id o5so91550874iod.2
        for <linux-media@vger.kernel.org>; Sat, 19 Mar 2016 16:55:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458417037-26691-1-git-send-email-luisbg@osg.samsung.com>
References: <1458417037-26691-1-git-send-email-luisbg@osg.samsung.com>
Date: Sat, 19 Mar 2016 20:55:15 -0300
Message-ID: <CABxcv==y2D=B7Rf-8PsMzHfeqaoetV5xJXNQt0ZSn7-WK0ZuLw@mail.gmail.com>
Subject: Re: [PATCH] fence: add missing descriptions for fence
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	sumit.semwal@linaro.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	linaro-mm-sig@lists.linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Luis,

On Sat, Mar 19, 2016 at 4:50 PM, Luis de Bethencourt
<luisbg@osg.samsung.com> wrote:
> Commit b55b54b5db33 ("staging/android: remove struct sync_pt")
> added the members child_list and active_list to the fence struct, but
> didn't add descriptions for these. Adding the descriptions.
>

Patches whose commit message mentions a specific commit that
introduced and issue, usually also have a "Fixes:" tag before the
S-o-B. For example this patch should have:

Fixes: b55b54b5db33 ("staging/android: remove struct sync_pt")
> Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
> ---
> Hi,
>
> Noticed this missing descriptions when running make htmldocs.
>
> Got the following warnings:
> .//include/linux/fence.h:84: warning: No description found for parameter 'child_list'
> .//include/linux/fence.h:84: warning: No description found for parameter 'active_list'
>
> Thanks :)
> Luis
>

Patch looks good to me.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
