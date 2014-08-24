Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sg1on0130.outbound.protection.outlook.com ([134.170.132.130]:31393
	"EHLO APAC01-SG1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752499AbaHXNAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Aug 2014 09:00:19 -0400
From: James Harper <james@ejbdigital.com.au>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: regression - missing fence.h
Date: Sun, 24 Aug 2014 12:44:30 +0000
Message-ID: <650ff72a9af3461b8981e3c415b76f41@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm building v4l against Debian Jessie (3.14.15) and I am getting this:

"
In file included from /usr/local/src/media_build/v4l/../linux/include/media/videobuf2-core.h:19:0,
                 from /usr/local/src/media_build/v4l/mcam-core.h:13,
                 from /usr/local/src/media_build/v4l/cafe-driver.c:35:
/usr/local/src/media_build/v4l/../linux/include/linux/dma-buf.h:33:25: fatal error: linux/fence.h: No such file or directory
 #include <linux/fence.h>
"

Any suggestions before I go digging? It worked previously.

Thanks

James

