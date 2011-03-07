Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3416 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1CGMFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 07:05:42 -0500
Message-ID: <35921a5ef7063ce95fbdb4d90ace6f6e.squirrel@webmail.xs4all.nl>
In-Reply-To: <SNT129-W5851A1521AAD5550EED000E5C70@phx.gbl>
References: <SNT129-W5851A1521AAD5550EED000E5C70@phx.gbl>
Date: Mon, 7 Mar 2011 13:05:40 +0100
Subject: Re: Media Build broken
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Peter Tilley" <peter_tilley13@hotmail.com>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>
> Seems that whilst the last round of build errors have been fixed but
> another has appeared.       Looks like the file ti_wilink_st.h can't be
> found.     Not the only person with this problem.     See also
> http://www.gossamer-threads.com/lists/mythtv/users/474287?nohighlight=1#474287

Should be fixed now. Not all drivers seems to be automatically enabled
when I do my daily build, I should look into that because otherwise I'd
have seen this yesterday.

Thanks for reporting this!

Regards,

        Hans

>
> /Pete
>
>
> CC [M] /home/peter/media_build/v4l/em28xx-cards.o
> CC [M] /home/peter/media_build/v4l/fmdrv_common.o
> /home/peter/media_build/v4l/fmdrv_common.c:41: fatal error:
> linux/ti_wilink_st.h: No such file or directory
> compilation terminated.
> make[3]: *** [/home/peter/media_build/v4l/fmdrv_common.o] Error 1
> make[2]: *** [_module_/home/peter/media_build/v4l] Error 2
> make[2]: Leaving directory `/usr/src/linux-headers-2.6.35-27-generic'
> make[1]: *** [default] Error 2
> make[1]: Leaving directory `/home/peter/media_build/v4l'
> make: *** [all] Error 2
> *** ERROR. Aborting ***


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

