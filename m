Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:50459 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbaIDCaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 22:30:15 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBC003PFUYDPQ40@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 22:30:13 -0400 (EDT)
Date: Wed, 03 Sep 2014 23:30:09 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 32/46] [media] e4000: simplify boolean tests
Message-id: <20140903233009.5825c1b3.m.chehab@samsung.com>
In-reply-to: <5407C01D.5090400@iki.fi>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <86da9d3c8d8ced8d61c8c57b774da2e7f7a2a4ef.1409775488.git.m.chehab@samsung.com>
 <5407AAA3.1090607@iki.fi> <20140903221215.3843a9e9.m.chehab@samsung.com>
 <5407C01D.5090400@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 04 Sep 2014 04:27:57 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> > By being shorter, a reviewer can read it faster and, at least for
> > me, it is a non-brain to understand !foo. On the other hand,
> > "false" is not part of standard C. So, it takes more time for my
> > brain to parse it.
> 
> No, it just opposite for me and many others.

Yeah, this is subjective, so different people have different views.

Yet, if you take a look on the numbers inside the Kernel, this
is what we have:

$ git grep "== false" |wc -l
622
$ git grep "false ==" |wc -l
41
$ git grep 'if (!' |wc -l
153125

Being 249 occurrences inside Documentation:

$ git grep 'if (!' |grep Docum|wc -l
249

$ git grep "false ==" |grep Docum |wc -l
0
$ git grep "== false" |grep Docum |wc -l
1

Where the only Documentation with == false is this one (at
Documentation/thermal/sysfs-api.txt):
    .no_hwmon: a boolean to indicate if the thermal to hwmon sysfs interface
               is required. when no_hwmon == false, a hwmon sysfs interface
               will be created. when no_hwmon == true, nothing will be done.
               In case the thermal_zone_params is NULL, the hwmon interface
               will be created (for backward compatibility).

Yet, at the only place where this is tested, the syntax is !foo:

drivers/thermal/thermal_core.c: if (!tz->tzp || !tz->tzp->no_hwmon) {

So, clearly, the vast majority of Kernel developers are using !foo.

> > Anyway, from my side, the real reasone for using it is not due to
> > that. It is that I (and other Kernel developers) run from time to
> > time static analyzers like smatch and coccinelle, in order to identify
> > real errors. Having a less-polluted log helps to identify the newer
> > errors/warnings.
> 
> Have you ever looked Documentation/CodingStyle ?
> How about that example, from CodingStyle:
> int fun(int a)
> {
> 	int result = 0;
> 	char *buffer = kmalloc(SIZE);
> 
> 	if (buffer == NULL)
> 		return -ENOMEM;

Well, buffer is not a boolean operator.

I would code myself with if (!buffer), but I accept patches with both ways,
and I've seen a mix of both usages inside the Kernel.

> 
> 	if (condition1) {
> 		while (loop1) {
> 			...
> 		}
> 		result = 1;
> 		goto out;
> 	}
> 	...
> out:
> 	kfree(buffer);
> 	return result;
> }
> 
> As it shows, it is (buffer == NULL) *not* (!buffer). And if you like to 
> do it differently then update CodingStyle first! Add clear mention that 
> it should be (!buffer) and change given example to match your style. 
> Otherwise, I am happy to do as CodingStyle shows!

It is not me opting for it. Someone's else added the coccinelle patch
upstream, and it got at least 2 different reviewers besides its author:

commit 8991058171f3536c0a8fbb50ad311689b8b74979
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Fri Feb 10 22:05:18 2012 +0100

    coccinelle: semantic patch for bool issues
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Michal Marek <mmarek@suse.cz>


Anyway, as I said, my main interest is to just shut up the in-Kernel
tests, as this helps to better identify real problems.

I don't care if this is done by someone sending a patch to remove
or modify the coccinelle script to accept both ways or to use the
approach taken by this patch.


> 
> Antti
> 
> >
> > Regards,
> > Mauro
> >>
> >> regards
> >> Antti
> >>
> >> On 09/03/2014 11:33 PM, Mauro Carvalho Chehab wrote:
> >>> Instead of using if (foo == false), just use
> >>> if (!foo).
> >>>
> >>> That allows a faster mental parsing when analyzing the
> >>> code.
> >>>
> >>> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >>>
> >>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> >>> index 90d93348f20c..cd9cf643f602 100644
> >>> --- a/drivers/media/tuners/e4000.c
> >>> +++ b/drivers/media/tuners/e4000.c
> >>> @@ -400,7 +400,7 @@ static int e4000_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> >>>    	struct e4000 *s = container_of(ctrl->handler, struct e4000, hdl);
> >>>    	int ret;
> >>>
> >>> -	if (s->active == false)
> >>> +	if (!s->active)
> >>>    		return 0;
> >>>
> >>>    	switch (ctrl->id) {
> >>> @@ -423,7 +423,7 @@ static int e4000_s_ctrl(struct v4l2_ctrl *ctrl)
> >>>    	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> >>>    	int ret;
> >>>
> >>> -	if (s->active == false)
> >>> +	if (!s->active)
> >>>    		return 0;
> >>>
> >>>    	switch (ctrl->id) {
> >>>
> >>
> 
