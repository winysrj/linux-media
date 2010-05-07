Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33725 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab0EGNK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 09:10:27 -0400
Received: by fxm10 with SMTP id 10so762882fxm.19
        for <linux-media@vger.kernel.org>; Fri, 07 May 2010 06:10:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100507093916.2e2ef8e3@pedra>
References: <20100507093916.2e2ef8e3@pedra>
Date: Fri, 7 May 2010 17:10:25 +0400
Message-ID: <x2w1a297b361005070610lda8d8d2ve90011bbfff320ee@mail.gmail.com>
Subject: Re: Status of the patches under review (85 patches) and some misc
	notes about the devel procedures
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 7, 2010 at 4:39 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Hi,
>

>
> This is the summary of the patches that are currently under review.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>
> P.S.: This email is c/c to the developers that some review action is expected.
>
> May, 7 2010: [v2] stv6110x Fix kernel null pointer deref when plugging two TT s2-16 http://patchwork.kernel.org/patch/97612


How is this patch going to fix a NULL ptr dereference when more than 1
card is plugged in ? The patch doesn't seem to do what the patch title
implies. At least the patch title seems to be wrong. Maybe the patch
is supposed to check for a possible NULL ptr dereference when put to
sleep ?
