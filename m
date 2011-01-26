Return-path: <mchehab@pedra>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:51323 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752647Ab1AZVtQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 16:49:16 -0500
Message-ID: <4D4096DA.804@teksavvy.com>
Date: Wed, 26 Jan 2011 16:49:14 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D405A9D.4070607@redhat.com> <4D4076FD.6070207@teksavvy.com> <20110126194127.GE29268@core.coreip.homeip.net> <4D407A46.4080407@teksavvy.com> <20110126195011.GF29268@core.coreip.homeip.net> <4D4094F3.3020607@teksavvy.com>
In-Reply-To: <4D4094F3.3020607@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Or perhaps get rid of that unworkable "version number" thing
(just freeze it in time with the 2.6.35 value returned),
and implement a "get_feature_flags" ioctl or something for going forward.
Then you can just turn on new bits in the flags as new features are added.

It's a kludge (to get around the poor use of -EINVAL everywhere),
but at least it's a design that's workable.

Cheers
