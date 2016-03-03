Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33653 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbcCCMsY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 07:48:24 -0500
Date: Thu, 3 Mar 2016 09:48:18 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC] Representing hardware connections via MC
Message-ID: <20160303094818.2d81aad2@recife.lan>
In-Reply-To: <1778959.zqGoLXbLC1@avalon>
References: <20160226091317.5a07c374@recife.lan>
	<20160302141643.GH11084@valkosipuli.retiisi.org.uk>
	<20160302124029.0e6cee85@recife.lan>
	<1778959.zqGoLXbLC1@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 03 Mar 2016 00:58:31 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:


> (Disclaimer: There are lots of thoughts in this e-mail, sometimes in a bit of 
> a random order. I would thus recommend reading through it completely before 
> starting to write a reply.)

I did read the entire e-mail. There are interesting things there, but we're
diverging from what it is needed. I intend to discuss about that later, but
let's focus on the problem. See below.

> > For S-Video, we may not need to represent two pads.  
> 
> Unless I'm mistaken, that's one of the fundamental questions we've been trying 
> to answer through our discussions on this topic. And I really think we should 
> answer it, it's the core of the problem we're trying to solve.

No, the core problem we're trying to solve are a way simpler than that.

1) how we'll call the entities that represent the connection with
external hardware;

2) how we document it?

3) how we map the cases where the S-Video adapter is used for composite.

For the first question, it seems that the current namespace is OK,
e. g. keep naming them as:

#define MEDIA_ENT_F_CONN_RF		(MEDIA_ENT_F_BASE + 0x30001)
#define MEDIA_ENT_F_CONN_SVIDEO		(MEDIA_ENT_F_BASE + 0x30002)
#define MEDIA_ENT_F_CONN_COMPOSITE	(MEDIA_ENT_F_BASE + 0x30003)

For the second question, it was addressed on this patch:
	https://patchwork.linuxtv.org/patch/33287/

For the third question, I can see only two possibilities:

a) create just one entity for S-Video, with 2 pads.

if S-Video is connected to it, both pads will be active;
if Composite is connected to it, just one pad will be active.

b) create a separate entity for "Composite over S-Video".

Questions (1) and (2) should be answered for Kernel 4.5.

Question (3) was rised by saa7134 driver. We don't need to provide
a solution for 4.5 (although it would be really great if we could
do it), as, right now, the "composite over S-Video" inputs are
not mapped via MC API: the driver just ignores them when
creating the connector entities.

Thanks,
Mauro
