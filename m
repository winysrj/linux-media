Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:31710 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbZELVSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:18:20 -0400
Received: by rv-out-0506.google.com with SMTP id f6so2154009rvb.5
        for <linux-media@vger.kernel.org>; Tue, 12 May 2009 14:18:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200905122058.n4CKwj2I004399@imap1.linux-foundation.org>
References: <200905122058.n4CKwj2I004399@imap1.linux-foundation.org>
Date: Tue, 12 May 2009 17:18:20 -0400
Message-ID: <829197380905121418o5e86d474n3ef38e91850ff818@mail.gmail.com>
Subject: Re: [patch 4/4] zoran: fix &&/|| error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 12, 2009 at 4:39 PM,  <akpm@linux-foundation.org> wrote:
> From: Roel Kluin <roel.kluin@gmail.com>
>
> Fix &&/|| typo. `default_norm' can be 0 (PAL), 1 (NTSC) or 2 (SECAM),
> the condition tested was impossible.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Hello,

Was the patch actually tested against the hardware in question?  While
I agree that it looks ok, it can result in the default logic being
inverted in some cases, which could expose other bugs and result in a
regression.

I just want to be confident that this patch was tested by somebody
with the hardware and it isn't going into the codebase because "it
obviously cannot be right".

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
