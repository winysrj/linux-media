Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab0HCAXq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Aug 2010 20:23:46 -0400
Message-ID: <4C5761AE.9050701@redhat.com>
Date: Mon, 02 Aug 2010 21:24:14 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 1/2] staging/lirc: port lirc_streamzap to ir-core
References: <20100802212922.GA17746@redhat.com> <20100802223510.GB2478@kroah.com>
In-Reply-To: <20100802223510.GB2478@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-08-2010 19:35, Greg KH escreveu:
> On Mon, Aug 02, 2010 at 05:29:22PM -0400, Jarod Wilson wrote:
>>  drivers/media/IR/keymaps/Makefile           |    1 +
> 
> Uppercase "IR"?  Any reason why you all picked that?

Infra Red. Well, it were not probably a good idea ;)

Anyway, I intend to rename it to "rc" (for Remote Controller), change lots of 
internal structures and eventually move it to drivers/ or drivers/input, as the
idea is to use the subsystem also to other kinds of remote controllers.

I'll likely do it after finishing the merge of the pending patches, and send
upstream during this merge window. It seems better to rename during the merge
window.
> 
> Just curious.
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,
Mauro
