Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw-out1.cc.tut.fi ([130.230.160.32]:49905 "EHLO
	mail-gw-out1.cc.tut.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2EYPEW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 11:04:22 -0400
Message-ID: <4FBF9BE8.3020300@iki.fi>
Date: Fri, 25 May 2012 17:49:12 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
References: <4FBE5518.5090705@redhat.com> <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com> <4FBEB72D.4040905@redhat.com> <CA+55aFyYQkrtgvG99ZOOhAzoKi8w5rJfRgZQy3Dqs39p1n=FPA@mail.gmail.com> <4FBF773B.10408@redhat.com>
In-Reply-To: <4FBF773B.10408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

25.05.2012 15:12, Mauro Carvalho Chehab kirjoitti:
> Em 24-05-2012 19:40, Linus Torvalds escreveu:
>> On Thu, May 24, 2012 at 3:33 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>>
>>> The Kconfig default for DVB_FE_CUSTOMISE is 'n'. So, if no DVB bridge is selected,
>>> nothing will be compiled.
>>
>> Sadly, it looks like the default for distro kernels is 'y'.
> 
> I'll change the default on Fedora (f16/f17/rawhide).
> 
>> Which means that if you start with a distro kernel config, and then
>> try to cut it down to match your system, you end up screwed in the
>> future - all the new hardware will default to on.
>>
>> At least that's how I noticed it. Very annoying.
> 
> A simple way to solve it seems to make those options dependent on CONFIG_EXPERT.
> 
> Not sure if all usual distributions disable it, but I guess most won't have
> EXPERT enabled.
> 
> The enclosed patch does that. If nobody complains, I'll submit it together
> with the next git pull request.
> 
> Regards,
> Mauro
> 
> -
> 
> [RFC PATCH] Make tuner/frontend options dependent on EXPERT
> 
> The media CUSTOMISE options are there to allow embedded systems and advanced
> users to disable tuner/frontends that are supported by a bridge driver to
> be disabled, in order to save some disk space and memory, when compiled builtin.
> 
> However, distros are mistakenly enabling it, causing problems when a
> make oldconfig is used.
> 
> Make those options dependent on EXPERT, in order to avoid such annoyance behavior.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
> index bbf4945..702a3bf 100644
> --- a/drivers/media/common/tuners/Kconfig
> +++ b/drivers/media/common/tuners/Kconfig
> @@ -35,6 +35,7 @@ config MEDIA_TUNER
>  config MEDIA_TUNER_CUSTOMISE
>  	bool "Customize analog and hybrid tuner modules to build"
>  	depends on MEDIA_TUNER
> +	depends on EXPERT
>  	default y if EXPERT
        ^^^^^^^^^^^^^^^^^^^

Hmm, why should CONFIG_EXPERT automatically mean that the tuner modules
should be customized? I'd think this shouldn't default to y even with
EXPERT.

Not a biggie, just thought I'd point it out :)

(as a sidenote, on Mageia kernels CONFIG_EXPERT is on... didn't check
why, could be just historical reasons)

>  	help
>  	  This allows the user to deselect tuner drivers unnecessary
> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
> index b98ebb2..6d3c2f7 100644
> --- a/drivers/media/dvb/frontends/Kconfig
> +++ b/drivers/media/dvb/frontends/Kconfig
> @@ -1,6 +1,7 @@
>  config DVB_FE_CUSTOMISE
>  	bool "Customise the frontend modules to build"
>  	depends on DVB_CORE
> +	depends on EXPERT
>  	default y if EXPERT

Ditto.

>  	help
>  	  This allows the user to select/deselect frontend drivers for their


-- 
Anssi Hannula
