Return-path: <mchehab@localhost>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34637 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1GFLqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2011 07:46:16 -0400
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Issa Gorissen'" <flop.m@usa.net>
Cc: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>,
	<abraham.manu@gmail.com>
References: <004e01cc37cb$1020b710$30622530$@coexsi.fr> <4E11B117.3010601@usa.net>
In-Reply-To: <4E11B117.3010601@usa.net>
Subject: RE: [DVB] Possible regression in stb6100 module for DVBS2 transponders
Date: Wed, 6 Jul 2011 13:46:12 +0200
Message-ID: <007301cc3bd2$4ed785a0$ec8690e0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>



> -----Original Message-----
> From: Issa Gorissen [mailto:flop.m@usa.net]
> Sent: lundi 4 juillet 2011 14:25
> To: "Sébastien RAILLARD (COEXSI)"
> Cc: Linux Media Mailing List; abraham.manu@gmail.com
> Subject: Re: [DVB] Possible regression in stb6100 module for DVBS2
> transponders
> 
> On 01/07/2011 10:44, Sébastien RAILLARD (COEXSI) wrote:
> > Dear Manu,
> >
> > I think there is a regression in your patch from December 2010
> > regarding the
> > stb6100 module.
> > With the latest version of stb6100 published in media_build git
> > branch, we can't tune the TT-S2-3200 on some DVBS2 transponders like
> > Hotbird 13E
> > 11681-H-27500 or Hotbird 13E 12692-H-27500.
> > After reverting to the previous stb6100_set_frequency function, it's
> > working fine.
> > So, there is maybe in issue in the last December code refactoring.
> >
> > Reference of the patch: "[media] stb6100: Improve tuner performance"
> > http://git.linuxtv.org/media_tree.git?a=history;f=drivers/media/dvb/fr
> > ontend s/stb6100.c;h=bc1a8af4f6e105181670ee33ebe111f98425e0ff;hb=HEAD
> >
> > See below for the code removed from the stb6100.c file (the
> > stb6100_set_frequency function) and the code added (the previous
> > stb6100_set_frequency function and the stb6100_write_regs function).
> >
> > Best regards,
> > Sebastien.
> 
> Reported back in may
> [http://www.mail-archive.com/linux-media@vger.kernel.org/msg31334.html]

I can confirm what was reported by Issa, my problem was solved after
applying these two patches:

1- https://patchwork.kernel.org/patch/244201/
Why this patch is noted as "refused"? 
It seems to solve the last issues encountered with the TT-S2-3200.

2- https://patchwork.kernel.org/patch/753392/
This patch is still in "RFC"

And removing this one that seem to introduce a regression, as noted before:
http://git.linuxtv.org/media_tree.git?a=commit;h=f14bfe94e459cb070a489e1786f
26d54e9e7b5de

Sebastien.






