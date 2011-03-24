Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:33076 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab1CXPeP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 11:34:15 -0400
Message-ID: <4D8B6475.6030707@matrix-vision.de>
Date: Thu, 24 Mar 2011 16:34:13 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: mchehab@redhat.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] ignore Documentation/DocBook/media/
References: <4D80C7BD.3030704@matrix-vision.de>
In-Reply-To: <4D80C7BD.3030704@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/16/2011 03:22 PM, Michael Jones wrote:
>>From 81a09633855b88d19f013d7e559e0c4f602ba711 Mon Sep 17 00:00:00 2001
> From: Michael Jones <michael.jones@matrix-vision.de>
> Date: Thu, 10 Mar 2011 16:16:38 +0100
> Subject: [PATCH] ignore Documentation/DocBook/media/
> 
> It is created and populated by 'make htmldocs'
> 
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  Documentation/DocBook/.gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/DocBook/.gitignore b/Documentation/DocBook/.gitignore
> index c6def35..679034c 100644
> --- a/Documentation/DocBook/.gitignore
> +++ b/Documentation/DocBook/.gitignore
> @@ -8,3 +8,4 @@
>  *.dvi
>  *.log
>  *.out
> +media/

In general, where do patches on this list land?  On
http://linuxtv.org/wiki/index.php/Developer_Section
the link to "Current git log" is broken.  The link to 'Git V4L-DVB
development repository' is v4l-dvb.git which is suspiciously inactive:
2.6.37-rc8, from 2 months ago.  Judging by the activity level, I guess
that patches from this mailing list currently land in branch
'staging/for_v2.6.39' of 'http://git.linuxtv.org/media_tree.git'?

And what's the destiny of this patch in particular?  It doesn't seem to
have even been picked up by patchwork.

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
