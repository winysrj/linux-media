Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:49215 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761919Ab0J2T7W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 15:59:22 -0400
Date: Fri, 29 Oct 2010 21:59:18 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
Message-ID: <20101029195918.GA12501@hardeman.nu>
References: <20101029031131.GE17238@redhat.com>
 <20101029031530.GH17238@redhat.com>
 <4CCAD01A.3090106@redhat.com>
 <20101029151141.GA21604@redhat.com>
 <20101029191711.GA12136@hardeman.nu>
 <20101029192733.GE21604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101029192733.GE21604@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 29, 2010 at 03:27:33PM -0400, Jarod Wilson wrote:
> On Fri, Oct 29, 2010 at 09:17:11PM +0200, David Härdeman wrote:
> > On Fri, Oct 29, 2010 at 11:11:41AM -0400, Jarod Wilson wrote:
> > > So the Apple remotes do something funky... One of the four bytes is a
> > > remote identifier byte, which is used for pairing the remote to a specific
> > > device, and you can change the ID byte by simply holding down buttons on
> > > the remote.
> > 
> > How many different ID's are possible to set on the remote?
> 
> 256, apparently.

Does the remote pick one for you at random?

-- 
David Härdeman
