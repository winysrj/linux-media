Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37695 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaJTQHP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Oct 2014 12:07:15 -0400
Received: by mail-vc0-f172.google.com with SMTP id lf12so3784033vcb.31
        for <linux-media@vger.kernel.org>; Mon, 20 Oct 2014 09:07:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544475D5.6080903@infradead.org>
References: <544475D5.6080903@infradead.org>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Mon, 20 Oct 2014 09:06:54 -0700
Message-ID: <CAP_ceTxY945D6vuPDz3gPUXN-YwnXX5zG6=GpBuohCcd+YTb=g@mail.gmail.com>
Subject: Re: [PATCH] DocBook: fix media build error
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 19, 2014 at 7:39 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix media DocBook build errors by making the orderedlist balanced.
>
> DOC1/Documentation/DocBook/compat.xml:2576: parser error : Opening and ending tag mismatch: orderedlist line 2560 and section
> DOC1/Documentation/DocBook/compat.xml:2726: parser error : Premature end of data in tag section line 884
> DOC1/Documentation/DocBook/compat.xml:2726: parser error : chunk is not well balanced
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vincent Palatin <vpalatin@chromium.org>
> ---
>  Documentation/DocBook/media/v4l/compat.xml |    1 +
>  1 file changed, 1 insertion(+)
>
> --- lnx-318-rc1.orig/Documentation/DocBook/media/v4l/compat.xml
> +++ lnx-318-rc1/Documentation/DocBook/media/v4l/compat.xml
> @@ -2566,6 +2566,7 @@ fields changed from _s32 to _u32.
>           <para>Added compound control types and &VIDIOC-QUERY-EXT-CTRL;.
>           </para>
>          </listitem>
> +      </orderedlist>
>        <title>V4L2 in Linux 3.18</title>
>        <orderedlist>
>         <listitem>

Compared to the original patch, it's actually also missing the
 </section>

<section>
which were lost in the merge.


-- 
Vincent
