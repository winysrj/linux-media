Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:35101 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0EYWGX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 18:06:23 -0400
Received: from [127.0.0.1] (p508169DE.dip.t-dialin.net [80.129.105.222])
	by dd16922.kasserver.com (Postfix) with ESMTPA id 271D610FC11C
	for <linux-media@vger.kernel.org>; Tue, 25 May 2010 23:59:40 +0200 (CEST)
Message-ID: <4BFC4858.8060403@helmutauer.de>
Date: Tue, 25 May 2010 23:59:52 +0200
From: Helmut Auer <vdr@helmutauer.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: v4l-dvb does not compile with kernel 2.6.34
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I just wanted to compile v4l-dvb for my Gen2VDR Ditribution with kernel 2.6.34, but it fails
because many modules are missing:

#include <linux/slab.h>

and are getting errors like:

/tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
'free_firmware':
/tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:252: error: implicit
declaration of function 'kfree'
/tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c: In function
'load_all_firmwares':
/tmp/portage/media-tv/v4l-dvb-hg-0.1-r3/work/v4l-dvb/v4l/tuner-xc2028.c:314: error: implicit
declaration of function

Am I missing something or is v4l-dvb broken ?

-- 
Helmut Auer, helmut@helmutauer.de
