Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab0JSSA6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 14:00:58 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9JI0vpq011764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Oct 2010 14:00:57 -0400
Date: Tue, 19 Oct 2010 14:00:56 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: Old patches sent via the Mailing list
Message-ID: <20101019180056.GE16942@redhat.com>
References: <4CBB689F.1070100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBB689F.1070100@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 17, 2010 at 07:20:31PM -0200, Mauro Carvalho Chehab wrote:
> Hi,
> 
> I did a large effort during this weekend to handle the maximum amount of patches, in order to have them
> ready for 2.6.37. While there are still some patches marked as NEW at patchwork, and a few pending pull
> requests (mostly related to more kABI changes), there are still a list of patches that are marked as
> Under review. Except for 4 patches from me, related to Doc (that I'm keeping in this list just to remind
> me that I'll need to fix them when I have some time - just some automation stuff at DocBook), all other
> patches marked as Under review are stuff that I basically depend on others.
> 
> The last time I sent this list, I was about to travel, and I may have missed some comments, or maybe I
> may just forgot to update. But I suspect that, for the list bellow, most of them are stuff where the
> driver maintainer just forgot at limbo.
> 
> From the list of patches under review, we have:
...
> 		== Waiting for Jarod Wilson <jarod@redhat.com> review/ack == 
> 
> Jun,20 2010: drivers/media/IR/imon.c: Use pr_err instead of err                     http://patchwork.kernel.org/patch/107025  Joe Perches <joe@perches.com>

Acked.

-- 
Jarod Wilson
jarod@redhat.com

