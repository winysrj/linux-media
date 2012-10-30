Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33841 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932497Ab2J3NIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 09:08:17 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so183155lag.19
        for <linux-media@vger.kernel.org>; Tue, 30 Oct 2012 06:08:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121030020619.6e854f70@redhat.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
	<20121028175752.447c39d5@redhat.com>
	<508EA1B8.3070304@googlemail.com>
	<20121029180348.7e7967aa@redhat.com>
	<508EF1CF.8090602@googlemail.com>
	<20121030010012.30e1d2de@redhat.com>
	<20121030020619.6e854f70@redhat.com>
Date: Tue, 30 Oct 2012 09:08:15 -0400
Message-ID: <CAGoCfiw+G2CnGJSum2k9M80XizKSTfw34gXZOkOZBp_OvSTtjQ@mail.gmail.com>
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2012 at 12:06 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Did a git bisect. The last patch where the bug doesn't occur is this
> changeset:
>         em28xx: add module parameter for selection of the preferred USB transfer type
>
> That means that this changeset broke it:
>
>         em28xx: use common urb data copying function for vbi and non-vbi devices

Oh good, when I saw the subject line for that patch, I got worried.
Looking at the patch, it seems like he just calls the VBI version for
both cases assuming the VBI version is a complete superset of the
non-VBI version, which it is clearly not.

That whole patch should just be reverted.  If he's going to spend the
time to refactor the code to allow the VBI version to be used for both
then fine, but blindly calling the VBI version without making real
code changes is *NOT* going to work.

Frank, good job in naming your patch - it made me scream "WAIT!" when
I saw it.  Bad job for blindly submitting a code change without any
idea whether it actually worked.  ;-)

I know developers have the tendency to look at code and say "oh,
that's ugly, I should change that."  However it's more important that
it actually work than it be pretty.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
