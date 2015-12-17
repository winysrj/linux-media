Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59101 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170AbbLQCT6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 21:19:58 -0500
Date: Thu, 17 Dec 2015 00:19:24 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuah.kh@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: Media Controller patches
Message-ID: <20151217001924.12c54a34@recife.lan>
In-Reply-To: <56720C1A.70103@osg.samsung.com>
References: <20151210183411.3d15a819@recife.lan>
	<20151211190522.4e4d62a0@recife.lan>
	<20151213091250.00df9420@recife.lan>
	<20151216154337.58f37568@recife.lan>
	<56720C1A.70103@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 16 Dec 2015 18:12:58 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> On 12/16/2015 10:43 AM, Mauro Carvalho Chehab wrote:
> > Em Sun, 13 Dec 2015 09:12:50 -0200
> > Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:
> > 
> 
> > 
> > As far as I know, all pending items for Kernel 4.5 merge are
> > complete. I should be moving the remaining patches from my
> > experimental tree:
> > 	git://linuxtv.org/mchehab/experimental.git media-controller-rc4
> > 
> > to the media-controller topic branch by the end of this week, if
> > nothing pops up.
> 
> Hi Mauro,
> 
> I don't like the flat graph I am seeing on experimental rc4
> with all the pending patches for 4.5. I am attaching two
> media graphs generated on au0828 on rc3 and rc4. Something
> is off with rc4.  I used the latest mc_nextgen_test tool
> to generate the graphs.

I guess this problem is due to the patch changed the object ID 
to use a single number range:
	http://git.linuxtv.org/mchehab/experimental.git/commit/?h=media-controller-rc4&id=9c04bcb45824fd8e5231f6f26269b57830c1f34d

We likely need to change the userspace tool due to that, but I'll
take a look on it tomorrow.

Regards,
Mauro
