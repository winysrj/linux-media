Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770Ab1GDASA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Jul 2011 20:18:00 -0400
Message-ID: <4E1106B0.7030102@redhat.com>
Date: Sun, 03 Jul 2011 21:17:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <4E10ECEA.6040808@redhat.com> <201107040124.04924@orion.escape-edv.de>
In-Reply-To: <201107040124.04924@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-07-2011 20:24, Oliver Endriss escreveu:
> Hi Mauro,
> 
> On Monday 04 July 2011 00:27:54 Mauro Carvalho Chehab wrote:
>> Hi Oliver,
>>
>> Em 03-07-2011 18:21, Oliver Endriss escreveu:
>>> [PATCH 1/5] ddbridge: Initial check-in
>>> [PATCH 2/5] ddbridge: Codingstyle fixes
>>> [PATCH 3/5] ddbridge: Allow compiling of the driver
>>> [PATCH 4/5] cxd2099: Fix compilation of ngene/ddbridge for DVB_CXD2099=n
>>> [PATCH 5/5] cxd2099: Update Kconfig descrition (ddbridge support)
>>>
>>> Note:
>>> This patch series depends on the previous one:
>>> [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099 and ngene
>>
>> I've applied both series today on an experimental tree that I use when merging
>> some complex drivers. They are at:
>> 	http://git.linuxtv.org/mchehab/experimental.git?a=shortlog;h=refs/heads/ngene
>>
>> I didn't actually reviewed the patch series yet, but I noticed some troubles
>> related to Coding Style, and 2 compilation breakages, when all drivers are selected,
>> due to some duplicated symbols. So, I've applied some patches fixing the issues
>> I noticed. It would be great if you could test if the changes didn't break anything.
> 
> Apparently these duplicated symbols did not show up here,
> because I compiled the drivers as modules. :-(

Likely. When merging things, I compile here with allyesconfig, in order to catch duplicated
symbols.

>> There's a problem that I've noticed already at the patch series: the usage of
>> CHK_ERROR macro hided a trouble on some places, especially at drxd_hard.c.
>>
>> As you know, the macro was defined as:
>> 	#define CHK_ERROR(s) if ((status = s)) break
>>
>> I've replaced it, on all places, using a small perl script, as the above is a CodingStyle
>> violation, and may hide some troubles[1].
> 
> True.
> 
>> [1] http://git.linuxtv.org/mchehab/experimental.git?a=commit;h=792ecdd1cc494a1e10ed494052ed697ab4e1aa8a
>>
>> After the removal, I've noticed that this works fine on several places
>> where the code have things like:
>> 	do {
>> 		status = foo()
>> 		if (status < 0)
>> 			break;
>>
>> 	} while (0);
>>
>> There are places, however, that there are two loops, like, for example, at:
>>
>> static int DRX_Start(struct drxd_state *state, s32 off)
>> {
>> ...
>> 	do {
>> ...
>> 		switch (p->transmission_mode) {
>> 		case TRANSMISSION_MODE_8K:
>> 			transmissionParams |= SC_RA_RAM_OP_PARAM_MODE_8K;
>> 			if (state->type_A) {
>> 				status = Write16(state, EC_SB_REG_TR_MODE__A, EC_SB_REG_TR_MODE_8K, 0x0000);
>> 				if (status < 0)
>> 					break;
>> 			}
>> 			break;
>> ...
>> 		}
>>
>> ...
>> 	} while (0);
>>
>> 	return status;
>>
>> On those cases, instead of returning the error status, the function
>> will just ignore the error and proceed to the next switch(). In this specific 
>> routine, as there are no locks inside the code, the better fix would be to 
>> just replace:
>> 	if (status < 0)
>> 		break;
>> by
>> 	if (status < 0)
>> 		return (status);
>>
>> But I suspect that the same trouble is also present on other parts of the code.
>>
>> Another issue that I've noticed alread is that, on some places, instead of doing 
>> "return -EINVAL" (or some other proper error code), the code is just doing: "return -1".
>>
>> Could you please take a look on those issues?
> 
> That CHK_ERROR stuff appears very dangerous to me.
> Btw, this is why I did not remove the curly braces { } in some cases:
>         if (...) {
>                 CHK_ERROR(...)
>         }
> It would have caused really nasty effects.

True. 

> Anyway, I spent the whole weekend to re-format the code carefully
> and create both patch series, trying not to break anything.
> I simply cannot go through the driver code and verify everything.

As the changes on CHK_ERROR were done via script, it is unlikely that it
introduced any problems (well, except if some function is returning
a positive value as an error code, but I think that this is not the
case).

I did the same replacement when I've cleanup the drx-d driver (well, the 
script were not the same, but it used a similar approach), and the changes 
didn't break anything, but it is safer to have a test, to be sure that no
functional changes were introduced.

A simple test with the code and some working board is probably enough
to verify that nothing broke.

The bad error check logic, checking for "break" inside two loops instead just
one will require a careful code inspection, though.

> Please note that I am not the driver author!
> I think Ralph should comment on this.

Ralph,

Could you please take a look on it?

Thanks!
Mauro
