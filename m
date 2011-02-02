Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59260 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1BBN6h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 08:58:37 -0500
Received: by eye27 with SMTP id 27so3741706eye.19
        for <linux-media@vger.kernel.org>; Wed, 02 Feb 2011 05:58:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimmvf++nF=mzHHQJ0-aMc2=aYJnwo-hYto75Mpc@mail.gmail.com>
References: <AANLkTimmvf++nF=mzHHQJ0-aMc2=aYJnwo-hYto75Mpc@mail.gmail.com>
Date: Wed, 2 Feb 2011 08:58:35 -0500
Message-ID: <AANLkTik3Fh6Q7LJZafwstpyEOgydBkJ=R83rLyK7pzV8@mail.gmail.com>
Subject: [PATCH RESEND] Fix bug in au0828 VBI streaming
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Jan 23, 2011 at 5:12 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Attached is a patch for a V4L2 spec violation with regards to the
> au0828 not working in streaming mode.
>
> This was just an oversight on my part when I did the original VBI
> support for this bridge, as libzvbi was silently falling back to using
> the read() interface.

Mauro,

Where are we at with this patch.  It's trivial and VBI is broken in
V4L2 streaming mode without it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
