Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA26C43612
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 19:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DBC82086D
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 19:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544900683;
	bh=1prbeQxrA9jIBYwYQ4/oSg6DXq+rSL5nCq1vSUE7qm4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=oGd97lQfnxHKJqsSeHpTOzkRO2aiNSqvgEy0PanVP16wSFaCDKpMs+VNa7xsWyeWL
	 9ybYDkHJULKESu8G7+jZA8Hh2aUJE6Qmo85TCMSnA99KtRDi0qDvXLlXWRaCltvKNM
	 Mnv2w6ItmA/9Gv9Rpc0PT8aDErbW5w1mG5PMd9C4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbeLOTEj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 14:04:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:56526 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbeLOTEi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 14:04:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uneCfvtfA7c+Zch7tQ/+DRjV1vUfHgLQT087QmDKITs=; b=RPq1NSOUgK8Pw4mziMzGTTXvO+
        erVuxQM9l6lX+GsHM0tRS9LDEiN4u/JaDJ47JMdS9zjUCJjzXlD6jldz9V5auHS+37p0ZWz9zx4aC
        y4ngly+geDdz7QcZYU+Yu57kkxK3bnPE1GENyfWU8chZz3Enm8Yvvoqm4GhDkBD9aI2UcefBaKhHT
        giKNR7Wff0HMWolOnMLTL9+EQpvcgrYMKjL6F9uaf3ITz5eXmBXobo/rgwV0/3wxMSwkheC4WxKMk
        UQNW78W5O5EFhInRLB1tfWKJPeQ6kIQZxxtiRH17MNZ6VxT2MxBQHGDf8BwWkno6voZtX6egHYLgE
        8s/6crqQ==;
Received: from 177.96.232.231.dynamic.adsl.gvt.net.br ([177.96.232.231] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gYFEp-0004PW-KL; Sat, 15 Dec 2018 19:04:36 +0000
Date:   Sat, 15 Dec 2018 17:04:31 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Helen Koike <helen.koike@collabora.com>
Cc:     "Lucas A. M. =?UTF-8?B?TWFnYWxow6Nlcw==?=" <lucmaga@gmail.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org
Subject: Re: [Lkcamp][PATCH] media: vimc: Add vimc-streamer for stream
 control
Message-ID: <20181215170431.419b0d0f@coco.lan>
In-Reply-To: <df515706-5649-abdb-2231-03dcf4517600@collabora.com>
References: <20181215164631.8623-1-lucmaga@gmail.com>
        <20181215160110.1a353219@coco.lan>
        <df515706-5649-abdb-2231-03dcf4517600@collabora.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Sat, 15 Dec 2018 16:38:41 -0200
Helen Koike <helen.koike@collabora.com> escreveu:

> Hi Mauro,
>=20
> On 12/15/18 4:01 PM, Mauro Carvalho Chehab wrote:
> > Hi Lucas,
> >=20
> >=20
> > Em Sat, 15 Dec 2018 14:46:31 -0200
> > Lucas A. M. Magalh=C3=A3es <lucmaga@gmail.com> escreveu:
> >  =20
> >> The previous code pipeline used the stack to walk on the graph and
> >> process a frame. Basically the vimc-sensor entity starts a thread that
> >> generates the frames and calls the propagate_process function to send
> >> this frame to each entity linked with a sink pad. The propagate_process
> >> will call the process_frame of the entities which will call the
> >> propagate_frame for each one of it's sink pad. This cycle will continue
> >> until it reaches a vimc-capture entity that will finally return and
> >> unstack. =20
> >=20
> > I didn't review the code yet, but I have a few comments about the
> > way you're describing this patch.
> >=20
> > When you mention about a "previous code pipeline". Well, by adding it
> > at the main body of the patch description, reviewers should expect
> > that you're mentioning an implementation that already reached upstream.
> >=20
> > I suspect that this is not the case here, as I don't think we merged
> > any recursive algorithm using the stack, as this is something that
> > we shouldn't do at Kernelspace, as a 4K stack is usually not OK
> > with recursive algorithms.
> >=20
> > So, it seems that this entire patch description (as-is) is bogus[1].
> >=20
> > [1] if this is not the case and a recursive approach was indeed
> > sneaked into the Kernel, this is a bug. So, you should really
> > use the "Fixes:" meta-tag indicating what changeset this patch is
> > fixing, and a "Cc: stable@vger.kernel.org", in order to hint
> > stable maintainers that this require backports. =20
>=20
> Just fyi, this is not the case, the current implementation in mainline
> is bogus indeed (implemented by me when I was starting kernel
> development, sorry about that and thanks Lucas for sending a fix). Not
> only when propagating the frame [1] but also when activating the
> pipeline [2].
>=20
> But in any case this should be better written in the commit message.
>=20
>=20
> [1]
> Every entity calls vimc_propagate_frame()
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/v=
imc-debayer.c#n506
> That calls the process_frame() of each entity directly connected, that
> calls vimc_propagate_frame() again:
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/v=
imc-common.c#n237
>=20
> [2]
> .s_stream is calling the .s_stream of the subdevices directly connected
> https://git.linuxtv.org/media_tree.git/tree/drivers/media/platform/vimc/v=
imc-debayer.c#n355
>=20
>=20
> I was actually wondering if this is worthy in sending this to stable, as
> this implementation is not a real problem, because the topology in vimc
> is hardcoded and limited, and according to:
> https://www.kernel.org/doc/Documentation/process/stable-kernel-rules.rst
> "It must fix a real bug that bothers people"
>=20
> So as the topology is fixed (in the current implementation), the max
> number of nested calls is 4 (in the sensor->debayer->scaler->capture
> path), this doesn't triggers any bug to users. But this will be a
> problem once we have the configfs API in vimc.
>=20
> You could say that if your memory is low, this can be a problem in the
> current implementation, but then your system won't have memory for any 4
> nested function calls anyway (which I think the kernel wouldn't work at
> all).

That basically depends on how much memory each call eats at stack.

It is not always trivial about the amount of memory a stack call uses,
and enabling KASAN can affect it a lot, as it changes some gcc optimization
parameters, and there are some of those that use stack to either
speedup the code or to allow checking for memory overrun. I'd say that it
would be safe if, at the worse case scenario, it would be allocating no
more than ~500 bytes at stack. Above that, it could be problematic.

On a quick glance, I would be expecting, that, for 4 nested calls, it
would use up to 256 bytes on 64 bits archs. For each call, it would use:=20

	1 64-bits pointer for function return pointer;
	2 64-bits pointers for the two function arguments;
	5 64-bits pointers for the temporary values.

All assuming that gcc won't be using registers for the above nor do any
other optimization. But you have to check the asm code to be sure.

Also, as I said, different Kconfig options could change the amount of
memory spent (optimization for size is enabled? KASAN is enabled? what
type of KASAN?).=20

>=20
> Mauro, with that said, do you still think we should send this to stable?

Yes, let's properly document it (please check the abount of stack it
is using with and without KASAN, for the worse case scenario) and
send it to stable.=20

Better safe than sorry.

>=20
> Thanks
> Helen
>=20
> >=20
> > Please notice that the patch description will be stored forever
> > at the git tree. Mentioning something that were never merged
> > (and that, years from now people will hardly remember, and will
> > have lots of trouble to seek as you didn't even mentioned any
> > ML archive with the past solution) shouldn't be done.
> >=20
> > So, you should rewrite the entire patch description explaining
> > what the current approach took by this patch does. Then, in order
> > to make easier for reviewers to compare with a previous implementation,
> > you can add a "---" line and then a description about why this approach
> > is better than the first version, e. g. something like:
> >=20
> > 	[PATCH v2] media: vimc: Add vimc-streamer for stream control
> >=20
> > 	Add a logic that will create a linear pipeline walking=20
> > 	backwards on the graph. When the stream starts it will simply
> > 	loop through the pipeline calling the respective process_frame
> > 	function for each entity on the pipeline.
> >=20
> > 	Signed-off-by: Your Name <your@email>
> >=20
> > 	---
> >=20
> > 	v2: The previous approach were to use a recursive function that
> > 	it was using the stack to walk on the graph and
> > 	process a frame. Basically the vimc-sensor entity starts a thread that
> > 	generates the frames and calls the propagate_process function to send
> > 	this frame to each entity linked with a sink pad. The propagate_process
> > 	will call the process_frame of the entities which will call the
> > 	propagate_frame for each one of it's sink pad. This cycle will continue
> > 	until it reaches a vimc-capture entity that will finally return and
> > 	unstack.
> > 	...
> >=20
> > If the past approach was written by somebody else (or if you sent it
> > a long time ago), please add an URL (if possible using=20
> > https://lore.kernel.org/linux-media/ archive) pointing to the previous=
=20
> > approach, in order to help us to check what you're referring to.
> >=20
> > Regards,
> > Mauro
> >=20
> > Thanks,
> > Mauro
> >  =20



Thanks,
Mauro
