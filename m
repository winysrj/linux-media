Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:24180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932784Ab0EDS1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 14:27:30 -0400
Date: Tue, 4 May 2010 11:26:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 4 (media & IR)
Message-Id: <20100504112606.56d1497d.randy.dunlap@oracle.com>
In-Reply-To: <20100504162305.4a07a18a.sfr@canb.auug.org.au>
References: <20100504162305.4a07a18a.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 May 2010 16:23:05 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100503:


drivers/media/video/vivi.c:1144: error: implicit declaration of function 'kfree'
drivers/media/video/vivi.c:1156: error: implicit declaration of function 'kzalloc'
drivers/media/video/vivi.c:1156: warning: assignment makes pointer from integer without a cast

drivers/media/video/mem2mem_testdev.c:862: error: implicit declaration of function 'kzalloc'
drivers/media/video/mem2mem_testdev.c:862: warning: assignment makes pointer from integer without a cast
drivers/media/video/mem2mem_testdev.c:874: error: implicit declaration of function 'kfree'
drivers/media/video/mem2mem_testdev.c:944: warning: assignment makes pointer from integer without a cast

drivers/media/IR/rc-map.c:51: error: implicit declaration of function 'msleep'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
