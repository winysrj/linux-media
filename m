Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:56272 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab1GDMZW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 08:25:22 -0400
Message-ID: <4E11B117.3010601@usa.net>
Date: Mon, 04 Jul 2011 14:24:55 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	abraham.manu@gmail.com
Subject: Re: [DVB] Possible regression in stb6100 module for DVBS2 transponders
References: <004e01cc37cb$1020b710$30622530$@coexsi.fr>
In-Reply-To: <004e01cc37cb$1020b710$30622530$@coexsi.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 01/07/2011 10:44, Sébastien RAILLARD (COEXSI) wrote:
> Dear Manu,
>
> I think there is a regression in your patch from December 2010 regarding the
> stb6100 module.
> With the latest version of stb6100 published in media_build git branch, we
> can't tune the TT-S2-3200 on some DVBS2 transponders like Hotbird 13E
> 11681-H-27500 or Hotbird 13E 12692-H-27500.
> After reverting to the previous stb6100_set_frequency function, it's working
> fine.
> So, there is maybe in issue in the last December code refactoring.
>
> Reference of the patch: "[media] stb6100: Improve tuner performance"
> http://git.linuxtv.org/media_tree.git?a=history;f=drivers/media/dvb/frontend
> s/stb6100.c;h=bc1a8af4f6e105181670ee33ebe111f98425e0ff;hb=HEAD
>
> See below for the code removed from the stb6100.c file (the
> stb6100_set_frequency function) and the code added (the previous
> stb6100_set_frequency function and the stb6100_write_regs function).
>
> Best regards,
> Sebastien.

Reported back in may
[http://www.mail-archive.com/linux-media@vger.kernel.org/msg31334.html]
