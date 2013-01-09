Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab3AIPCJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jan 2013 10:02:09 -0500
Date: Wed, 9 Jan 2013 13:01:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
Message-ID: <20130109130134.00b8d86c@redhat.com>
In-Reply-To: <50ED824E.708@schinagl.nl>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
	<50EAC41D.4040403@schinagl.nl>
	<20130108200149.GB408@linuxtv.org>
	<50ED3BBB.4040405@schinagl.nl>
	<20130109084143.5720a1d6@redhat.com>
	<20130109084425.7ac6dc50@redhat.com>
	<50ED4CEB.3050303@schinagl.nl>
	<20130109100438.748924c8@redhat.com>
	<50ED616D.1070108@schinagl.nl>
	<20130109123758.7d91ab5a@redhat.com>
	<50ED824E.708@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 09 Jan 2013 15:44:30 +0100
Oliver Schinagl <oliver+list@schinagl.nl> escreveu:

> Mauro,
> 
> On 09-01-13 15:37, Mauro Carvalho Chehab wrote:
> > Hi Oliver,
> >
> > Em Wed, 09 Jan 2013 13:24:13 +0100
> > Oliver Schinagl <oliver@schinagl.nl> escreveu:
> >
> >>>>>> If I understood it right, you want to split the scan files into a separate
> >>>>>> git tree and maintain it, right?
> >>>>>>
> >>>>>> I'm ok with that.
> <snip>
> >>>>> I also migrated the dvb-apps changesets with the tables to: 
> >>>>> http://git.linuxtv.org/dtv-scan-tables.git Feel free to maintain it.
> Thank you, this will be the new name for it (I will locally rename it) 
> and try my bestest to maintain it :)
> 
> I will put a mention on the wiki 'how to submit scanfiles' (via the ML 
> with tags in subject/pull requests) so people have a clear way how to 
> submit them and I have a clear way to find them.

Great!

> >
> > You should also have access to the dvb-apps hg tree. IMHO, it makes sense
> > to remove the files from there, and add a pointer there (README?) to the
> > new tree.
> I will remove the scanfiles from there, add/edit the readme that the 
> tree is a dependancy?

Please do it. You'll likely need to also add there at the tree a Makefile
with an install target, in order to help distros to package it, and
remove the corresponding scan files install Makefile targets at dvb-apps.

-- 

Cheers,
Mauro
