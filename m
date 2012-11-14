Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64387 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab2KNRFR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 12:05:17 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so396348qcr.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 09:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A3CDCD.6020900@googlemail.com>
References: <loom.20121111T054512-795@post.gmane.org>
	<50A3CDCD.6020900@googlemail.com>
Date: Wed, 14 Nov 2012 12:05:16 -0500
Message-ID: <CAGoCfiwd0Dt49sZO_XEkv5rGwCj+nEDz0sGxw_j8oxKXE=NQAQ@mail.gmail.com>
Subject: Re: The em28xx driver error
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Michael Yang <yze007@gmail.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 11:58 AM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> This looks indeed like a bug.
> a >>= b means a = a >> b, which in this case means shifting height 480
> or 576 bits to the right...
> height >> 1 means height /= 2 which seems to be sane for interlaced devices.
> OTOH, I wonder why it seems to be working on other platforms !?
> Unfortunately I don't have an interlaced device here for testing. :(

It's definitely a bug.  I think Mauro put a patch in for 3.7 or 3.8.
The reason it works under x86 is because shifting an arbitrary number
of bits > 32 causes indeterminate behavior, and out of dumb luck it
has no effect on x86.

But yeah, I changed the code to shift by one bit and it's been working
fine on ARM for months in my environment (DM3730).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
