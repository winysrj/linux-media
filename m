Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:44369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761851Ab0J2UJk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 16:09:40 -0400
Date: Fri, 29 Oct 2010 16:09:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101029200937.GG21604@redhat.com>
References: <20101029031131.GE17238@redhat.com>
 <20101029031530.GH17238@redhat.com>
 <4CCAD01A.3090106@redhat.com>
 <20101029151141.GA21604@redhat.com>
 <20101029191711.GA12136@hardeman.nu>
 <20101029192733.GE21604@redhat.com>
 <20101029195918.GA12501@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101029195918.GA12501@hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 29, 2010 at 09:59:18PM +0200, David Härdeman wrote:
> On Fri, Oct 29, 2010 at 03:27:33PM -0400, Jarod Wilson wrote:
> > On Fri, Oct 29, 2010 at 09:17:11PM +0200, David Härdeman wrote:
> > > On Fri, Oct 29, 2010 at 11:11:41AM -0400, Jarod Wilson wrote:
> > > > So the Apple remotes do something funky... One of the four bytes is a
> > > > remote identifier byte, which is used for pairing the remote to a specific
> > > > device, and you can change the ID byte by simply holding down buttons on
> > > > the remote.
> > > 
> > > How many different ID's are possible to set on the remote?
> > 
> > 256, apparently.
> 
> Does the remote pick one for you at random?

Looks like its randomly set at the factory, then holding a particular key
combo on the remote for 5 seconds, you can cycle to another one. Not sure
if "another one" means "increment by one" or "randomly pick another one"
yet though.

-- 
Jarod Wilson
jarod@redhat.com

