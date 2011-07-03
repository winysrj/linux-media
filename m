Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:38362 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751183Ab1GCXYb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 19:24:31 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices bridge (ddbridge)
Date: Mon, 4 Jul 2011 01:24:03 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ralph Metzler <rjkm@metzlerbros.de>
References: <201107032321.46092@orion.escape-edv.de> <4E10ECEA.6040808@redhat.com>
In-Reply-To: <4E10ECEA.6040808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107040124.04924@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Monday 04 July 2011 00:27:54 Mauro Carvalho Chehab wrote:
> Hi Oliver,
> 
> Em 03-07-2011 18:21, Oliver Endriss escreveu:
> > [PATCH 1/5] ddbridge: Initial check-in
> > [PATCH 2/5] ddbridge: Codingstyle fixes
> > [PATCH 3/5] ddbridge: Allow compiling of the driver
> > [PATCH 4/5] cxd2099: Fix compilation of ngene/ddbridge for DVB_CXD2099=n
> > [PATCH 5/5] cxd2099: Update Kconfig descrition (ddbridge support)
> > 
> > Note:
> > This patch series depends on the previous one:
> > [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099 and ngene
> 
> I've applied both series today on an experimental tree that I use when merging
> some complex drivers. They are at:
> 	http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/ngene
> 
> I didn't actually reviewed the patch series yet, but I noticed some troubles
> related to Coding Style, and 2 compilation breakages, when all drivers are selected,
> due to some duplicated symbols. So, I've applied some patches fixing the issues
> I noticed. It would be great if you could test if the changes didn't break anything.

Apparently these duplicated symbols did not show up here,
because I compiled the drivers as modules. :-(

> There's a problem that I've noticed already at the patch series: the usage of
> CHK_ERROR macro hided a trouble on some places, especially at drxd_hard.c.
> 
> As you know, the macro was defined as:
> 	#define CHK_ERROR(s) if ((status = s)) break
> 
> I've replaced it, on all places, using a small perl script, as the above is a CodingStyle
> violation, and may hide some troubles[1].

True.

> [1] http://git.linuxtv.org/mchehab/experimental.git?a=commit;h=792ecdd1cc494a1e10ed494052ed697ab4e1aa8a
> 
> After the removal, I've noticed that this works fine on several places
> where the code have things like:
> 	do {
> 		status = foo()
> 		if (status < 0)
> 			break;
> 
> 	} while (0);
> 
> There are places, however, that there are two loops, like, for example, at:
> 
> static int DRX_Start(struct drxd_state *state, s32 off)
> {
> ...
> 	do {
> ...
> 		switch (p->transmission_mode) {
> 		case TRANSMISSION_MODE_8K:
> 			transmissionParams |= SC_RA_RAM_OP_PARAM_MODE_8K;
> 			if (state->type_A) {
> 				status = Write16(state, EC_SB_REG_TR_MODE__A, EC_SB_REG_TR_MODE_8K, 0x0000);
> 				if (status < 0)
> 					break;
> 			}
> 			break;
> ...
> 		}
> 
> ...
> 	} while (0);
> 
> 	return status;
> 
> On those cases, instead of returning the error status, the function
> will just ignore the error and proceed to the next switch(). In this specific 
> routine, as there are no locks inside the code, the better fix would be to 
> just replace:
> 	if (status < 0)
> 		break;
> by
> 	if (status < 0)
> 		return (status);
> 
> But I suspect that the same trouble is also present on other parts of the code.
> 
> Another issue that I've noticed alread is that, on some places, instead of doing 
> "return -EINVAL" (or some other proper error code), the code is just doing: "return -1".
> 
> Could you please take a look on those issues?

That CHK_ERROR stuff appears very dangerous to me.
Btw, this is why I did not remove the curly braces { } in some cases:
        if (...) {
                CHK_ERROR(...)
        }
It would have caused really nasty effects.

Anyway, I spent the whole weekend to re-format the code carefully
and create both patch series, trying not to break anything.
I simply cannot go through the driver code and verify everything.
Please note that I am not the driver author!

I think Ralph should comment on this.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
