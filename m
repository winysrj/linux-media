Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab0HZTbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 15:31:03 -0400
Date: Thu, 26 Aug 2010 15:14:50 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Proposed ir-core (rc-core) changes
Message-ID: <20100826191450.GA11951@redhat.com>
References: <20100824225427.13006.57226.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100824225427.13006.57226.stgit@localhost.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Aug 25, 2010 at 01:01:57AM +0200, David Härdeman wrote:
> The following series merges the different files that currently make up
> the ir-core module into a single-file rc-core module.
> 
> In addition, the ir_input_dev and ir_dev_props structs are replaced
> by a single rc_dev struct with an API similar to that of the input
> subsystem.
> 
> This allows the removal of all knowledge of any input devices from the
> rc drivers and paves the way for allowing multiple input devices per
> rc device in the future. The namespace conversion from ir_* to rc_*
> should mostly be done for the drivers with this patchset.
> 
> I have intentionally not signed off on the patches yet since they haven't
> been tested. I'd like your feedback on the general approach before I spend
> the time to properly test the result.
> 
> Also, the imon driver is not converted (and will thus break with this
> patchset). The reason is that the imon driver wants to generate mouse
> events on the input dev under the control of rc-core. I was hoping that
> Jarod would be willing to convert the imon driver to create a separate
> input device for sending mouse events to userspace :)

Yeah, I could be persuaded to do that. Means that the imon driver, when
driving one of the touchscreen devices, will bring up 3 separate input
devices, but oh well. (I'd actually considered doing that when porting to
ir-core in the first place, but went the lazy route. ;)

> Comments please...

Haven't tried it out at all yet or done more than a quick skim through the
patches, but at first glance, I do like the idea of further abstracting
away the input layer. I know I tanked a few things the first go 'round,
thinking I needed to do both some rc-layer and input-layer setup and/or
teardown. It becomes more cut and dry if you don't see anything
input-related anywhere at all.

One thing I did note with the patches is that a lot of bits were altered
from ir-foo to rc-foo, but not all of them... If we're going to make the
change, why no go whole hog? (Or was it only things relevant to ir
specifically right now that didn't get renamed?)

-- 
Jarod Wilson
jarod@redhat.com

