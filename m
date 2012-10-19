Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:52415 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2JSKRG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 06:17:06 -0400
Date: Fri, 19 Oct 2012 11:17:04 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: [PATCH] rc-core: add separate defines for protocol bitmaps and
 numbers
Message-ID: <20121019101703.GA20317@pequod.mess.org>
References: <20121011231154.22683.2502.stgit@zeus.hardeman.nu>
 <20121017161856.GA10964@pequod.mess.org>
 <20121018215921.GA18904@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121018215921.GA18904@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 18, 2012 at 11:59:21PM +0200, David Härdeman wrote:
> On Wed, Oct 17, 2012 at 05:18:56PM +0100, Sean Young wrote:
> >On Fri, Oct 12, 2012 at 01:11:54AM +0200, David Härdeman wrote:
> >> The RC_TYPE_* defines are currently used both where a single protocol is
> >> expected and where a bitmap of protocols is expected. This patch tries
> >> to separate the two in preparation for the following patches.
> >
> >I'm not sure why this is needed.
> 
> I'm not sure I can explain it much better.
> 
> Something like rc_keydown() or functions which add/remove entries to the
> keytable want a single protocol. Future userspace APIs would also
> benefit from numeric protocols (rather than bitmap ones). Keytables are
> smaller if they can use a small(ish) integer rather than a bitmap.
> 
> Other functions or struct members (e.g. allowed_protos,
> enabled_protocols, etc) accept multiple protocols and need a bitmap.
> 
> Using different types reduces the risk of programmer error. Using a
> protocol enum whereever possible also makes for a more future-proof
> user-space API as we don't need to worry about a sufficient number of
> bits being available (e.g. in structs used for ioctl() calls).
> 
> The use of both a number and a corresponding bit is dalso one in e.g.
> the input subsystem as well (see all the references to set/clear bit when
> changing keytables for example).
> 
> >
> >> The intended use is also clearer to anyone reading the code. Where a
> >> single protocol is expected, enum rc_type is used, where one or more
> >> protocol(s) are expected, something like u64 is used.
> >
> >Having two sets of #define and enums for the same information is not
> >necessarily clearer.
> 
> Not only two set of define and enum, two different data types. To me it
> helps a lot to be able to tell from a function declaration whether it
> expects *a* protocol or protocols.

Right, thanks for elaborating. Makes sense.


Sean
