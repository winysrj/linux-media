Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5234 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0BDJ1V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Feb 2010 04:27:21 -0500
Date: Thu, 4 Feb 2010 10:28:47 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Richard =?iso-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
Message-ID: <20100204092846.GA3336@sortiz.org>
References: <4B66C36A.4000005@pelagicore.com>
 <4B693ED7.4060401@redhat.com>
 <20100203100326.GA3460@sortiz.org>
 <4B694D69.1090201@redhat.com>
 <20100203123617.GF3460@sortiz.org>
 <4B69B12D.6030105@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B69B12D.6030105@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 03, 2010 at 05:23:57PM +0000, Mauro Carvalho Chehab wrote:
> > Ok, thanks again for your understanding. This is definitely material for the
> > next merge window, so I'll merge it into my for-next branch.
> 
> The last version of the driver is OK for merging. However, I noticed one issue:
> it depends on two drivers that were already merged on my tree:
> 
> +config RADIO_TIMBERDALE
> +       tristate "Enable the Timberdale radio driver"
> +       depends on MFD_TIMBERDALE && VIDEO_V4L2
> +       select RADIO_TEF6862
> +       select RADIO_SAA7706H
> 
> Currently, the dependency seems to happen only at Kconfig level.
> 
> Maybe the better is to return to the previous plan: apply it via my tree, as the better
> is to have it added after those two radio i2c drivers.
I'm fine with that. Richard sent me a 2nd version of his patch that I was
about to merge.
Richard, could you please post this patch here, or to lkml with Mauro cc'ed ?
I'll add my SOB to it and then it will go through Mauro's tree.

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

