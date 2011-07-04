Return-path: <mchehab@pedra>
Received: from rcsinet14.oracle.com ([148.87.113.126]:55374 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1GDUdu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 16:33:50 -0400
Date: Mon, 4 Jul 2011 13:31:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 4 (media/radio)
Message-Id: <20110704133157.7a37d8d9.randy.dunlap@oracle.com>
In-Reply-To: <20110704170952.1024e89b.sfr@canb.auug.org.au>
References: <20110704170952.1024e89b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 4 Jul 2011 17:09:52 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110701:
> 
> The v4l-dvb tree gained a build failure so I used the version from
> next-20110701.


drivers/media/radio/radio-rtrack2.c:31:17: error: invalid suffix "c" on integer constant
make[4]: [drivers/media/radio/radio-rtrack2.o] Error 1 (ignored)
drivers/media/radio/radio-aimslab.c:49:17: error: invalid suffix "f" on integer constant
make[4]: [drivers/media/radio/radio-aimslab.o] Error 1 (ignored)
drivers/media/radio/radio-gemtek.c:51:18: error: invalid suffix "c" on integer constant
make[4]: [drivers/media/radio/radio-gemtek.o] Error 1 (ignored)
drivers/media/radio/radio-zoltrix.c:51:17: error: invalid suffix "c" on integer constant


These drivers do not handle hex CONFIG_ values correctly.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
