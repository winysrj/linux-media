Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44694
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1044852AbdDWKbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Apr 2017 06:31:39 -0400
Date: Sun, 23 Apr 2017 07:31:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Maximiliano Curia <maxy@debian.org>
Cc: linux-media@vger.kernel.org, David Fries <David@Fries.net>
Subject: Re: [David@Fries.net: [PATCH] xawtv allow ./configure
 --disable-alsa to compile when alsa is available]
Message-ID: <20170423073115.57258f63@vento.lan>
In-Reply-To: <20170423093929.5bvnf4zjhsg3rfub@gnuservers.com.ar>
References: <20170423093929.5bvnf4zjhsg3rfub@gnuservers.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maximiliano,

Em Sun, 23 Apr 2017 11:39:29 +0200
Maximiliano Curia <maxy@debian.org> escreveu:

> Hi,
> 
> I've received a patch for xawtv made by David Fries (I maintain xawtv in 
> Debian) that I think it would be nice to include in the xawtv3 [1] git repository and in 
> the next bug fix release. Currently I don't have commit access and I'm 
> not subscribed to the linux-media mailing list because I haven't received a reply 
> about my subscription request.

Perhaps you sent an e-mail to the ML with HTML. Vger server simply
discards any e-mail with html on its body.

> I'm contacting you (Mauro) as you committed the latest patches in 
> the git repository, could you please review and/or push the 
> patch below?

Patch looks OK. Just applied upstream:
	https://git.linuxtv.org/xawtv3.git/commit/?id=e398d70f5361934710a1f9b47bde2c010d0c97a6

> 
> I'm also CCing the mailing list but I don't expect it to reach it. If the mail 
> reaches the list, please cc me in the reply.

The past e-mail had html stuff on it. I had to manually fix the
patch, as there were some "=3D" characters on it.

This answer should be c/c to the mailing list ;)

> 
> Please let me know if there is an easier way to contact the linux-media group.

You don't need to subscribe to linux-media to send e-mails to it,
but you should be sure that your emailer is sending emails in
plain text only, and, if sending patches on it, that it won't
mangle the patch.

If you're just sending a new patch, the best would likely to use
git send-email[1] to send patches.

[1] https://git-scm.com/docs/git-send-email

> 
> Happy hacking,
> 
> [1]: https://git.linuxtv.org/xawtv3.git
> 
> ----- Forwarded message from David Fries <David@Fries.net> -----
> 
> Date: Sat, 25 Mar 2017 13:25:54 -0500
> From: David Fries <David@Fries.net>
> To: Maximiliano Curia <maxy@gnuservers.com.ar>
> User-Agent: Mutt/1.5.23 (2014-03-12)
> Subject: [PATCH] xawtv allow ./configure --disable-alsa to compile when alsa is available
> 
> alsa_loopback is used outside of the HAVE_ALSA check, always define
> it.  Disable alsa_stream.c or the alsa functions are missing symbols.
> ---
> I'm debugging a webcam problem, the 'motion' program works once, then
> fails, xawtv unwedges the camera so it can run again.  In trying to
> figure out what xawtv is doing that motion isn't, I went to compile
> without audio to cut down on the ioctls to look at and turns out
> xawtv using audio IS what is unwedging the camera.  That's no good for
> the uvc USB camera driver, or camera, to require audio be setup for it
> to work properly.  Here's a patch to fixup xawtv to compile without
> alsa.  Thanks for supporting this small little program, I would have
> never thought to look at audio otherwise.
> 
>  common/alsa_stream.c | 2 +-
>  console/radio.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/common/alsa_stream.c b/common/alsa_stream.c
> index 3e33b5e..85e10b4 100644
> --- a/common/alsa_stream.c
> +++ b/common/alsa_stream.c
> @@ -28,7 +28,7 @@
> 
>  #include "config.h"
> 
> -#ifdef HAVE_ALSA_ASOUNDLIB_H
> +#if defined(HAVE_ALSA_ASOUNDLIB_H) && defined(HAVE_ALSA)
> 
>  #include <stdio.h>
>  #include <stdlib.h>
> diff --git a/console/radio.c b/console/radio.c
> index 186fd3c..d4f7d57 100644
> --- a/console/radio.c
> +++ b/console/radio.c
> @@ -62,8 +62,8 @@
>     USB radio devices benefit from a larger default latency */
>  #define DEFAULT_LATENCY 500
> 
> -#if defined(HAVE_ALSA)
>  int alsa_loopback = 1;
> +#if defined(HAVE_ALSA)
>  char *alsa_playback = NULL;
>  char *alsa_capture = NULL;
>  int alsa_latency = DEFAULT_LATENCY;



Thanks,
Mauro
