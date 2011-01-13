Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:55642 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756285Ab1AMK5G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 05:57:06 -0500
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 1E2E0D4808E
	for <linux-media@vger.kernel.org>; Thu, 13 Jan 2011 11:56:58 +0100 (CET)
Date: Thu, 13 Jan 2011 11:59:53 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-ID: <20110113115953.4636c392@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The following changes since commit
353b61709a555fab9745cb7aea18e1c376c413ce:

  [media] radio-si470x: Always report support for RDS (2011-01-11 14:44:28 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.38

Jean-François Moine (9):
      gspca: Version change.
      gspca: Remove __devinit, __devinitconst and __devinitdata
      gspca: Remove useless instructions
      gspca - ov519: Cleanup source and add a comment
      gspca - ov534: Clearer debug messages
      gspca - ov534: Propagate errors to higher level
      gspca - ov534: Use the new video control mechanism
      gspca - sonixj: Infrared bug fix and enhancement
      gspca - sonixj: Add LED (illuminator) control to the webcam 0c45:614a.

 drivers/media/video/gspca/benq.c             |    2 +-
 drivers/media/video/gspca/conex.c            |    4 +-
 drivers/media/video/gspca/cpia1.c            |    2 +-
 drivers/media/video/gspca/etoms.c            |    4 +-
 drivers/media/video/gspca/finepix.c          |    2 +-
 drivers/media/video/gspca/gl860/gl860.c      |    2 +-
 drivers/media/video/gspca/gspca.c            |    2 +-
 drivers/media/video/gspca/jeilinj.c          |    2 +-
 drivers/media/video/gspca/jpeg.h             |    4 +-
 drivers/media/video/gspca/konica.c           |    2 +-
 drivers/media/video/gspca/m5602/m5602_core.c |    2 +-
 drivers/media/video/gspca/mars.c             |    2 +-
 drivers/media/video/gspca/mr97310a.c         |    2 +-
 drivers/media/video/gspca/ov519.c            |    8 +-
 drivers/media/video/gspca/ov534.c            |  473 +++++++-------------------
 drivers/media/video/gspca/ov534_9.c          |    2 +-
 drivers/media/video/gspca/pac207.c           |    2 +-
 drivers/media/video/gspca/pac7302.c          |    4 +-
 drivers/media/video/gspca/pac7311.c          |    4 +-
 drivers/media/video/gspca/sn9c2028.c         |    2 +-
 drivers/media/video/gspca/sn9c20x.c          |    2 +-
 drivers/media/video/gspca/sonixb.c           |    4 +-
 drivers/media/video/gspca/sonixj.c           |   92 +++---
 drivers/media/video/gspca/spca1528.c         |    2 +-
 drivers/media/video/gspca/spca500.c          |    2 +-
 drivers/media/video/gspca/spca501.c          |    2 +-
 drivers/media/video/gspca/spca505.c          |    2 +-
 drivers/media/video/gspca/spca508.c          |    2 +-
 drivers/media/video/gspca/spca561.c          |    2 +-
 drivers/media/video/gspca/sq905.c            |    2 +-
 drivers/media/video/gspca/sq905c.c           |    2 +-
 drivers/media/video/gspca/sq930x.c           |    2 +-
 drivers/media/video/gspca/stk014.c           |    2 +-
 drivers/media/video/gspca/stv0680.c          |    2 +-
 drivers/media/video/gspca/stv06xx/stv06xx.c  |    2 +-
 drivers/media/video/gspca/sunplus.c          |    2 +-
 drivers/media/video/gspca/t613.c             |    2 +-
 drivers/media/video/gspca/tv8532.c           |    2 +-
 drivers/media/video/gspca/vc032x.c           |    2 +-
 drivers/media/video/gspca/xirlink_cit.c      |    2 +-
 drivers/media/video/gspca/zc3xx.c            |    2 +-
 41 files changed, 218 insertions(+), 443 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
