Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44108 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750732Ab0DWPST (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 11:18:19 -0400
Subject: Re: Xawtv version 3.96
From: Chicken Shack <chicken.shack@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4BD19F77.2020303@redhat.com>
References: <4BD19F77.2020303@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 17:18:21 +0200
Message-ID: <1272035901.4167.5.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 23.04.2010, 10:24 -0300 schrieb Mauro Carvalho Chehab:
> For those that haven't notice yet, we're fixing some bugs at xawtv 3. Probably, we
> won't be adding new features on it, but we want to keep it on a sane state, in order
> to allow people to use it as a reference application on driver development.
> 
> I've just committed a few patches I wrote yesterday that backports some of the 
> Fedora 12 patches to xawtv, and fixed a few bugs on it. As result, after having all 
> dependencies installed, xawtv should compile fine with a recent distro (tested here 
> with Fedora 12 and RHEL 5).
> 
> The version was increased to 3.96.
> 
> As usual, all commit messages are sent to linuxtv-commits mailing list. So, people
> that are interested on tracking what's happening can subscribe to the list.
> 
> Cheers,
> Mauro.
> 
> -------- Mensagem original --------
> Assunto: [git:xawtv3/master] Increase version to 3.96
> Data: Fri, 23 Apr 2010 14:47:57 +0200
> De: Mauro Carvalho Chehab <mchehab@redhat.com>
> Responder a: linux-media@vger.kernel.org
> Para: linuxtv-commits@linuxtv.org
> 
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/xawtv3.git tree:
> 
> Subject: Increase version to 3.96
> Author:  Mauro Carvalho Chehab <mchehab@redhat.com>
> Date:    Fri Apr 23 09:37:43 2010 -0300
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  Changes    |   10 ++++++++++
>  xawtv.spec |    2 +-
>  2 files changed, 11 insertions(+), 1 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/xawtv3.git?a=commitdiff;h=091c0a39d56419253cc501a121c81655c94296e7
> 
> diff --git a/Changes b/Changes
> index fa941ff..916c373 100644
> --- a/Changes
> +++ b/Changes
> @@ -1,4 +1,14 @@
>  
> +3.96
> +====
> + * misc minor fixes collected at Fedora 12.
> + * Fix requement of /dev/vbi instead of /dev/vbi0 on scantv.
> + * Fix compilation with Xorg and remove the --x_libraries parameter from
> +   the configure script (as, on Xorg, X11 libraries are at /usr/lib).
> + * Now, providing that all build dependencies are satisfied, just typing
> +   make after the download is enough to generate/run configure and build
> +   the tools.
> +
>  3.95
>  ====
>  
> diff --git a/xawtv.spec b/xawtv.spec
> index d390d1b..77b4098 100644
> --- a/xawtv.spec
> +++ b/xawtv.spec
> @@ -1,7 +1,7 @@
>  Name:         xawtv
>  Group:        Applications/Multimedia
>  Autoreqprov:  on
> -Version:      3.95
> +Version:      3.96
>  Release:      0
>  License:      GPL
>  Summary:      v4l applications
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 

It would make much more sense to complete (or at least try to complete)
xawtv 4.0 pre instead of fixing bugs in 3.96.

Reasons why?

1. 4.0 pre contains more innovation, new ideas.
2. 3.96 s analogue only, not DVB.
3. Both the analogue AND the DVB driver development section do need
reference applications for driver development: 4.0 pre contains BOTH:
reference apps for analogue AND DVB driver development.

Cheers

CS



