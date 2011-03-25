Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab1CYPu2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 11:50:28 -0400
Message-ID: <4D8CB9C0.1000005@redhat.com>
Date: Fri, 25 Mar 2011 12:50:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] HVR-900 R2 and PCTV 330e DVB support
References: <AANLkTi=hppcpARY1DOOJwK7kyKPe+2Q415jt8dNh8Z=-@mail.gmail.com>
In-Reply-To: <AANLkTi=hppcpARY1DOOJwK7kyKPe+2Q415jt8dNh8Z=-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Devin,

Em 24-03-2011 14:05, Devin Heitmueller escreveu:
> This patch series finally merges in Ralph Metzler's drx-d driver and
> brings up the PCTV 330e and
> HVR-900R2.  The patches have been tested for quite some time by users
> on the Kernel Labs blog,
> and they have been quite happy with them.
> 
> The firmware required can be found here:
> 
> http://kernellabs.com/firmware/drxd/
> 
> The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:
> 
>   [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)
> 
> are available in the git repository at:
>   git://sol.kernellabs.com/dheitmueller/drx.git drxd
> 
> Devin Heitmueller (12):
>       drx: add initial drx-d driver
>       drxd: add driver to Makefile and Kconfig
>       drxd: provide ability to control rs byte
>       em28xx: enable support for the drx-d on the HVR-900 R2
>       drxd: provide ability to disable the i2c gate control function
>       em28xx: fix GPIO problem with HVR-900R2 getting out of sync with drx-d
>       em28xx: include model number for PCTV 330e
>       em28xx: add digital support for PCTV 330e
>       drxd: move firmware to binary blob
>       em28xx: remove "not validated" flag for PCTV 330e
>       em28xx: add remote control support for PCTV 330e
>       drxd: Run lindent across sources

Still lots of CodingStyle issues, but they could be easily cleaned by a few scripting.
I've cleaned them and added at my experimental tree:
	http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/drxd

It compiles fine, and I don't think that any of the changes would break DRX-D, but, in
any case, it would be great if you could double check.

I noticed just one issue with the drxd driver: it is still using a semaphore instead
of a mutex:

+       struct semaphore mutex;
...
+static int HI_CfgCommand(struct drxd_state *state)
+{
+       int status = 0;
+
+       down(&state->mutex);

It should be doing:

	s/struct semaphore/struct mutex/
	s/down/mutex_lock/
	s/up/mutex_unlock/
	s/sema_init/mutex_init/

at the places it occur.

I've added a patch for it at the end of the series.

Could you please double check if everything is ok, for me to move this upstream?

Thanks!
Mauro
