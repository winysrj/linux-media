Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQKH3He010049
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 15:17:03 -0500
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQKGosb029420
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 15:16:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Wed, 26 Nov 2008 21:16:42 +0100
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
In-Reply-To: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811262116.42364.hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@nokia.com>,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wednesday 26 November 2008 19:44:51 Trilok Soni wrote:
> This patch was living at linux-omap GIT tree from long time and seem
> to survive the testing. It is also used in N800/N810 Internet Tablet.
> Sakari Ailus can give more information about this. I am not able to
> submit this patch as inline one due to my git-send-email
> configuration with Gmail.

Hi Trilok,

I found a few problems with this patch:

1) The makefile isn't right: it compiles omap24xxcam.c and 
omap24xxcam-dma.c as two modules, but I suspect you want only one since 
the symbols that omap24xxcam.c needs from omap24xxcam-dma.c are not 
exported. See e.g. the msp3400 driver in the Makefile for how to do it.

2) The Kconfig is probably missing a ARCH_OMAP dependency (sounds 
reasonable, at least), so now it also compiles for the i686 but that 
architecture doesn't have a clk_get function.

3) I was wondering whether Sakari also wants to add a Signed-off-by 
line? Looking at the comments it seems that he was involved as well.

4) I get a bunch of compile warnings (admittedly when compiling for 
i686) that you might want to look at. Compiled against the 2.6.27 
kernel with gcc-4.3.1. It might be bogus since I didn't compile for the 
omap architecture.

  CC [M]  /home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.o
In file included 
from /home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.c:42:
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h: In 
function 'omap24xxcam_reg_in':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:549: warning: passing 
argument 1 of 'readl' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h: In 
function 'omap24xxcam_reg_out':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:555: warning: passing 
argument 2 of 'writel' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h: In 
function 'omap24xxcam_reg_merge':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:563: warning: passing 
argument 1 of 'readl' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:565: warning: passing 
argument 2 of 'writel' makes pointer from integer without a cast
  CC [M]  /home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam-dma.o
In file included 
from /home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam-dma.c:32:
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h: In 
function 'omap24xxcam_reg_in':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:549: warning: passing 
argument 1 of 'readl' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h: In 
function 'omap24xxcam_reg_out':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:555: warning: passing 
argument 2 of 'writel' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h: In 
function 'omap24xxcam_reg_merge':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:563: warning: passing 
argument 1 of 'readl' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam.h:565: warning: passing 
argument 2 of 'writel' makes pointer from integer without a cast
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam-dma.c: In 
function 'omap24xxcam_dma_hwinit':
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam-dma.c:357: warning: 
passing argument 1 of '_spin_lock_irqsave' discards qualifiers from 
pointer target type
/home/hans/work/src/v4l/v4l-dvb/v4l/omap24xxcam-dma.c:361: warning: 
passing argument 1 of '_spin_unlock_irqrestore' discards qualifiers 
from pointer target type


Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
