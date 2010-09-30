Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab0I3MOc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 08:14:32 -0400
Message-ID: <4CA47F22.5020405@redhat.com>
Date: Thu, 30 Sep 2010 09:14:26 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.37] gspca for_2.6.37
References: <20100925111805.3d093ce7@tele>
In-Reply-To: <20100925111805.3d093ce7@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 25-09-2010 06:18, Jean-Francois Moine escreveu:
> The following changes since commit
> dace3857de7a16b83ae7d4e13c94de8e4b267d2a:
> 
>   V4L/DVB: tvaudio: remove obsolete tda8425 initialization (2010-09-24 19:20:20 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/jfrancois/gspca.git for_2.6.37
> 
> Jean-François Moine (6):
>       gspca - benq: Display error messages when gspca debug disabled.
>       gspca - benq: Remove useless module load/unload messages.
>       gspca - cpia1: Fix compilation warning when gspca debug disabled.
>       gspca - many subdrivers: Handle INPUT as a module.


Please, don't do that:

+#if defined(CONFIG_INPUT) || defined(CONFIG_INPUT_MODULE)
 #include <linux/input.h>
+#endif

It would be a real mess if we start doing it for every include that have
depencencies on kernel. Instead, just keep the include there.

I applied the other patches from this series, keeping this one waiting
for your version 2.


>       gspca - spca505: Remove the eeprom write commands of NxUltra.
>       gspca - sonixj: Propagate USB errors to higher level.
> 
>  drivers/media/video/gspca/benq.c            |   20 ++----
>  drivers/media/video/gspca/cpia1.c           |    2 +
>  drivers/media/video/gspca/konica.c          |    8 ++-
>  drivers/media/video/gspca/ov519.c           |    6 +-
>  drivers/media/video/gspca/pac207.c          |    6 +-
>  drivers/media/video/gspca/pac7302.c         |    6 +-
>  drivers/media/video/gspca/pac7311.c         |    6 +-
>  drivers/media/video/gspca/sn9c20x.c         |    6 +-
>  drivers/media/video/gspca/sonixb.c          |    6 +-
>  drivers/media/video/gspca/sonixj.c          |   91 +++++++++++++++++++++------
>  drivers/media/video/gspca/spca505.c         |    4 -
>  drivers/media/video/gspca/spca561.c         |    8 ++-
>  drivers/media/video/gspca/stv06xx/stv06xx.c |    6 +-
>  drivers/media/video/gspca/zc3xx.c           |    6 +-
>  14 files changed, 119 insertions(+), 62 deletions(-)
> 

