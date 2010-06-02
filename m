Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261Ab0FBRxC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jun 2010 13:53:02 -0400
Message-ID: <4C069A7F.50104@redhat.com>
Date: Wed, 02 Jun 2010 14:53:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 2/3] tm6000: move debug info print from header into c
 file
References: <1275221944-27887-1-git-send-email-stefan.ringel@arcor.de> <1275221944-27887-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1275221944-27887-2-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 30-05-2010 09:19, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> move debug info print from header into c file

I don't see why to duplicate the printk's on every file. It seems better to me to
just keep them at the header file, and use tm6000_debug symbol for every tm6000
module.

Btw, I've applied a CodingStyle fix patch on my tree, together with the other patches.
As it touches on almost all drivers, it is better to merge from my tree ASAP.

I dunno why, but your rewrite copy_streams didn't apply fine, but this time I've fixed
the issues manually. I tested it here with two cards (Saphire Wonder TV - a 10moons clone,
based on tm5600 - and HVR900H), and the merge worked fine.

With your patch, image seems to be working fine (yet, I didn't re-add the memset(0) to
double check). However, running on a remote machine, via fast ethernet, the buffering
effect is seeing. Probably, there's still some trouble at the routine that fills the
buffers.

-

I suggest that you and Dmitri to use staging/tm6000 branch for development. this will
likely help to avoid conflict issues.

As usual, before submitting a patch, it would be wise to rebase it against upstream
with:
	git remote update
	git pull . staging/tm6000
	git rebase staging/tm6000

After doing it, please compile and test, before submitting me the patches.

Cheers,
Mauro.

