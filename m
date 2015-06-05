Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58627 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422712AbbFEPEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2015 11:04:54 -0400
Date: Fri, 5 Jun 2015 12:04:48 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sean Young <sean@mess.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>,
	Himangi Saraogi <himangi774@gmail.com>,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 08/11] [media] ir: Fix IR_MAX_DURATION enforcement
Message-ID: <20150605120448.3d385b64@recife.lan>
In-Reply-To: <20150605150043.GA3245@gofer.mess.org>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
	<3de7135934d936e630a39a047bdf731a51713dd4.1433514004.git.mchehab@osg.samsung.com>
	<20150605145538.GA3076@gofer.mess.org>
	<20150605150043.GA3245@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 05 Jun 2015 16:00:43 +0100
Sean Young <sean@mess.org> escreveu:

> On Fri, Jun 05, 2015 at 03:55:38PM +0100, Sean Young wrote:
> > On Fri, Jun 05, 2015 at 11:27:41AM -0300, Mauro Carvalho Chehab wrote:
> > > Don't assume that IR_MAX_DURATION is a bitmask. It isn't.
> > 
> > The patch is right, but note that IR_MAX_DURATION is 0xffffffff, and in
> > all these cases it is being compared to a u32, so it is always false.
> > 
> > Should these statements simply be removed? None of the other drivers
> > do these checks.
> 
> Sorry please ignore me, I should have read the whole patch series. :(

Yeah, patch 9/11 addresses it. We'll very likely need a check against
a maximum value. The Y2038 patches converting several timestamps to 64 bits.

Regards,
Mauro
