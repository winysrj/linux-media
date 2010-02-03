Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:27867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0BCMex (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 07:34:53 -0500
Date: Wed, 3 Feb 2010 13:36:18 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
Message-ID: <20100203123617.GF3460@sortiz.org>
References: <4B66C36A.4000005@pelagicore.com>
 <4B693ED7.4060401@redhat.com>
 <20100203100326.GA3460@sortiz.org>
 <4B694D69.1090201@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B694D69.1090201@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 03, 2010 at 10:18:17AM +0000, Mauro Carvalho Chehab wrote:
> Samuel Ortiz wrote:
> > I'm going to review this patch right now. Typically, mfd core drivers and
> > their subdevices are submitted as a patchset via my tree, because the
> > subdevices drivers have dependencies with the core. The mfd core driver is
> > submitted without any dependencies, and then when the subdevices drivers are
> > submitted, we add relevant code to the mfd driver. This way we prevent any
> > build breakage or bisection mess.
> 
> The drivers at media are generally very complex with dependencies on several other
> subsystems. In general, almost all depends on i2c, alsa and input, and an increasing
> number of drivers has also dependencies with platform_data added at arch-dependent
> includes/drivers. Yet, this specific driver is simple.
> 
> I generally tend to add those drivers via my tree, since it is generally simpler to
> prevent breakage/bisection troubles, 
I see that we have similar issues :)



> but it is also ok for me if you want to add
> them via your tree, after I get my ack.
Great, let's to that then.


> > The timberdale chip right now doesnt depend on anything, but will soon depend
> > on the radio driver that's on your tree, but also on a sound and on a network
> > driver. You'd have to take all those if Richard wants to push them right now.
> 
> There were one or two minor changes requested on radio-timb patchset. After that
> changes, we're ready to merge it.
All right, I'd appreciate if you could cc me on the relevant thread.



> > So, what I propose is to take the timberdale mfd core driver and the radio
> > one, with your SOB. Then when Richard wants to submit additional subdevices
> > drivers I'll be able to take them and we'll avoid polluting your tree with non
> > media related drivers. Does that make sense to you ?
> 
> Yes, it does. I don't think Richard is urging with those patches, so my idea is
> to keep them for linux-next. It would equally work for me if you add the patches
> on your tree after my ack. The only merge conflicts we may expect from V4L side
> are related to Kconfig/Makefile, and those will be easy to fix during the merge
> period.
Ok, thanks again for your understanding. This is definitely material for the
next merge window, so I'll merge it into my for-next branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

