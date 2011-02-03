Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53406 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1BCXi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Feb 2011 18:38:27 -0500
Received: by ewy5 with SMTP id 5so1037579ewy.19
        for <linux-media@vger.kernel.org>; Thu, 03 Feb 2011 15:38:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik3Fh6Q7LJZafwstpyEOgydBkJ=R83rLyK7pzV8@mail.gmail.com>
References: <AANLkTimmvf++nF=mzHHQJ0-aMc2=aYJnwo-hYto75Mpc@mail.gmail.com>
	<AANLkTik3Fh6Q7LJZafwstpyEOgydBkJ=R83rLyK7pzV8@mail.gmail.com>
Date: Thu, 3 Feb 2011 18:38:25 -0500
Message-ID: <AANLkTikyiS5_pkP_ALu3ogDioF+uqdA2D4H00Vz8iQsX@mail.gmail.com>
Subject: Re: [PATCH RESEND] Fix bug in au0828 VBI streaming
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Feb 2, 2011 at 8:58 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Sun, Jan 23, 2011 at 5:12 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> Attached is a patch for a V4L2 spec violation with regards to the
>> au0828 not working in streaming mode.
>>
>> This was just an oversight on my part when I did the original VBI
>> support for this bridge, as libzvbi was silently falling back to using
>> the read() interface.
>
> Mauro,
>
> Where are we at with this patch.  It's trivial and VBI is broken in
> V4L2 streaming mode without it.

Mauro,

I see this has been committed for 2.6.39.  Given the trivial nature,
can we get it in there for 2.6.38 as well?  It's a bugfix and the
au0828 VBI support is new to 2.6.38.  If it doesn't go in, then the
VBI support will be present but broken for a full release cycle.  This
could definitely cause problems for existing applications that now
detect the presence of VBI support, but then break when they try to
use it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
