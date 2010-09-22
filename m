Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497Ab0IVSjH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 14:39:07 -0400
Message-ID: <4C9A4D47.3080605@redhat.com>
Date: Wed, 22 Sep 2010 15:39:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mats Randgaard <mats.randgaard@tandberg.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] davinci & videobuf fixes
References: <201009071123.25174.hverkuil@xs4all.nl>
In-Reply-To: <201009071123.25174.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-09-2010 06:23, Hans Verkuil escreveu:
> Hi Mauro,
> 
> The following changes since commit 50b9d21ae2ac1b85be46f1ee5aa1b5e588622361:
>   Jarod Wilson (1):
>         V4L/DVB: mceusb: add two new ASUS device IDs
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/v4l-dvb.git for-2.6.37
> 
> Hans Verkuil (1):
>       videobuf-dma-sg: set correct size in last sg element

Ok.
> 
> Mats Randgaard (5):
>       videobuf-core.c: Replaced BUG_ON with WARN_ON

Why? Please provide a description to allow us to understand why this change makes sense.
Is there any condition where this would be acceptable?

>       vpif_cap/disp: Removed section mismatch warning
>       vpif_cap/disp: Replaced kmalloc with kzalloc
>	vpif_cap: don't ignore return code of videobuf_poll_stream()

The better would be to provide some description for all patches, but, in this
specific case, they're trivial.

Applied, thanks.

>       vpif_cap/disp: Fixed strlcpy NULL pointer bug

Hmm... this one doesn't make sense to me. Instead, you should be sure that
config->card_name (or cap->card) is always filled.

Ok, I've applied 4 of the 6 patches (I've included the patch of the last email
on the above).

Please, provide a better solution for the strlcpy NULL pointer bug, properly
filling the config struct in all cases.

Cheers,
Mauro
