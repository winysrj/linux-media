Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIFNwmS024150
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 10:23:58 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBIFNglS023806
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 10:23:42 -0500
Date: Thu, 18 Dec 2008 16:23:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <damm@igel.co.jp>
Message-ID: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Paul Mundt <lethal@linux-sh.org>,
	linux-sh@vger.kernel.org
Subject: A patch got applied to v4l bypassing v4l lists
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

Hi Magnus, Paul,

just stumbled upon a patch

sh: sh_mobile ceu clock framework support

http://marc.info/?l=linux-sh&m=122545217725877&w=2

with diffstat

 arch/sh/boards/board-ap325rxa.c            |    2 +-
 arch/sh/boards/mach-migor/setup.c          |    2 +-
 drivers/media/video/sh_mobile_ceu_camera.c |   20 +++++++++++++++++++-
 3 files changed, 21 insertions(+), 3 deletions(-)

that has been pulled through linux-sh ML and the sh tree without even 
being cc-ed to the v4l list, which wasn't a very good idea IMHO. Now this 
patch has to be manually "back-ported" to v4l hg repos using the 
"kernel-sync:" tag and only in part, because arch/sh directory is not in 
hg at all. Can we please avoid this in the future?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
