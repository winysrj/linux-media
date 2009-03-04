Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46988 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZCDCuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2009 21:50:25 -0500
Received: by ewy25 with SMTP id 25so2575225ewy.37
        for <linux-media@vger.kernel.org>; Tue, 03 Mar 2009 18:50:22 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: kilgota@banach.math.auburn.edu
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
Date: Tue, 3 Mar 2009 20:50:13 -0600
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200903032050.13915.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 March 2009 18:12:33 kilgota@banach.math.auburn.edu wrote:
> Hans, Jean-Francois, and Kyle,
>
> The proposed patches are not very long, so I will give each of them, with
> my comments after each, to explain why I believe that these changes are a
> good idea.
>
> First, the patch to libv4lconvert is short and sweet:
>
> contents of file mr97310av4l.patch follow
> ----------------------------------------------
> --- mr97310a.c.old	2009-03-01 15:37:38.000000000 -0600
> +++ mr97310a.c.new	2009-02-18 22:39:48.000000000 -0600
> @@ -102,6 +102,9 @@ void v4lconvert_decode_mr97310a(const un
>   	if (!decoder_initialized)
>   		init_mr97310a_decoder();
>
> +	/* remove the header */
> +	inp += 12;
> +
>   	bitpos = 0;
>
>   	/* main decoding loop */
>
> ----------------- here ends the v4lconvert patch ------------------
>
> The reason I want to do this should be obvious. It is to preserve the
> entire header of each frame over in the gspca driver, and to throw it away
> over here. The SOF marker FF FF 00 FF 96 is also kept. The reason why all
> of this should be kept is that it makes it possible to look at a raw
> output and to know if it is exactly aligned or not. Furthermore, the next
> byte after the 96 is a code for the compression algorithm used, and the
> bytes after that in the header might be useful in the future for better
> image processing. In other words, these headers contain information which
> might be useful in the future and they should not be jettisoned in the
> kernel module.
>

No complaints here.  I copied off of the pac207 driver, thinking that one 
compression format == one pixel format and that all mr97310a cameras use the 
same compression.  I was hesitant to say that the mr97310a pixel format can 
correspond to multiple compression formats, especially since I only have one 
such camera and I don't know if it's preferred to use multiple pixel formats 
for this reason.

>From what I understand, sending the frame header to userspace solves at least 
two problems (if indeed the compression is specified in the header):

* One frame may be compressed and the next frame isn't, or the next frame uses 
a different compression.

* Two cameras with the same vendor/product ID use different compression 
formats.  Distinguishing the two cameras in the kernel driver could be messy.

Just a random thought, but maybe the pac207 driver can benefit from such a 
change as well?

-Kyle
