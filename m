Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:60190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935780AbZDIQcF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 12:32:05 -0400
Message-ID: <49DE2301.5090406@e-tobi.net>
Date: Thu, 09 Apr 2009 18:32:01 +0200
From: Tobi <listaccount@e-tobi.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Userspace issue with DVB driver includes
References: <49DDA100.1030205@e-tobi.net> <20090409074534.2cf32df0@pedra.chehab.org>
In-Reply-To: <20090409074534.2cf32df0@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:

> I suspect that this were the upstream change that affected your work, right?
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b852d36b86902abb272b0f2dd7a56dd2d17ea88c

Yes, at least I thought so.

> There are two changesets that will likely fix this issue:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=85efde6f4e0de9577256c5f0030088d3fd4347c1
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9adfbfb611307060db54691bc7e6d53fdc12312b
> 
> Could you please try to apply they on 2.6.29 and see if those will solve the
> issue? If so, then we should probably add those on 2.6.29.2. 

I've applied both patches to 2.6.29.1, but the problem still remains.

It's hard to figure out, who to blame for this.

Tobias
