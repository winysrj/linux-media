Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:1119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0L0LoR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 06:44:17 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBiHeA014616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:44:17 -0500
Received: from gaivota (vpn-11-156.rdu.redhat.com [10.11.11.156])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oBRBd1iR001764
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 06:44:16 -0500
Date: Mon, 27 Dec 2010 09:38:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] Documentation/ioctl/ioctl-number.txt: Remove some now
 freed ioctl ranges
Message-ID: <20101227093839.09aebd15@gaivota>
In-Reply-To: <cover.1293449547.git.mchehab@redhat.com>
References: <cover.1293449547.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The V4L1 removal patches removed a few ioctls. Update it at the docspace.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 63ffd78..49d7f00 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -260,14 +260,11 @@ Code  Seq#(hex)	Include File		Comments
 't'	80-8F	linux/isdn_ppp.h
 't'	90	linux/toshiba.h
 'u'	00-1F	linux/smb_fs.h		gone
-'v'	all	linux/videodev.h	conflict!
 'v'	00-1F	linux/ext2_fs.h		conflict!
 'v'	00-1F	linux/fs.h		conflict!
 'v'	00-0F	linux/sonypi.h		conflict!
-'v'	C0-CF	drivers/media/video/ov511.h	conflict!
 'v'	C0-DF	media/pwc-ioctl.h	conflict!
 'v'	C0-FF	linux/meye.h		conflict!
-'v'	C0-CF	drivers/media/video/zoran/zoran.h	conflict!
 'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
 'w'	all				CERN SCI driver
 'y'	00-1F				packet based user level communications
-- 
1.7.3.4


