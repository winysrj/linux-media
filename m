Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54035 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0GITjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jul 2010 15:39:25 -0400
Received: by fxm14 with SMTP id 14so1329912fxm.19
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 12:39:22 -0700 (PDT)
Message-ID: <4C377AE7.9070404@googlemail.com>
Date: Fri, 09 Jul 2010 21:39:19 +0200
From: Sven Barth <pascaldragon@googlemail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Mike Isely <isely@isely.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Status of the patches under review at LMML (60 patches)
References: <4C332A5F.4000706@redhat.com> <alpine.DEB.1.10.1007072223310.14650@ivanova.isely.net>
In-Reply-To: <alpine.DEB.1.10.1007072223310.14650@ivanova.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 08.07.2010 05:31, Mike Isely wrote:
> These are cx25840 patches and I'm not the maintainer of that module.  I
> can't really speak to the correctness of the changes.  Best I can do is
> to try the patch with a few pvrusb2-driven devices here that use the
> cx25840 module.  I've done that now (HVR-1950 and PVR-USB2 model 24012)
> and everything continues to work fine.

I also retested the patch (with the recent v4l changes) and my device 
continues to work as expected (using your current snapshot from July, 
Mike :) ).

> Note, this part of the patch:
>
>   		int hw_fix = state->pvr150_workaround;
> -
> -		if (std == V4L2_STD_NTSC_M_JP) {
> +			if (std == V4L2_STD_NTSC_M_JP) {
>   			/* Japan uses EIAJ audio standard */
>   			cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
>   		} else if (std == V4L2_STD_NTSC_M_KR) {
>
> is a whitespace-only change which introduces a bogus tab and messes up
> the indentation of that opening if-statement.  It should probably be
> removed from the patch.

I wonder how that came in there... my excuses for this (and also the 
removed new line some lines below that).

> Other than that, you have my ack:
>
> Acked-By: Mike Isely<isely@pobox.com>
>
>    -Mike
>
>

Hmm... I've read a bit in the wiki about submitting patches and read 
that one should sign-off his/her patches... as I didn't do that back 
then (as I thought that patch would be open for discussion ^^ - note to 
self: add RFC next time), should I resend the patch with a comment and 
the sign-off (and excluding the indentation mistake) or should I just 
send a sign-off in reference to this patch? Or something else?

Regards,
Sven
