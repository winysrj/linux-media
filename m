Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:39987 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab0LYRJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 12:09:14 -0500
Received: from tele (unknown [82.245.201.222])
	by smtp5-g21.free.fr (Postfix) with ESMTP id E8644D480A9
	for <linux-media@vger.kernel.org>; Sat, 25 Dec 2010 18:09:08 +0100 (CET)
Date: Sat, 25 Dec 2010 18:11:30 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] gspca for_2.6.38
Message-ID: <20101225181130.520bd9f4@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The following changes since commit
884d09f0d9f2eb6848c71fd024c250816f835572:

  [media] drivers:media:dvb: add USB PIDs for Elgato EyeTV Sat (2010-12-22 15:57:42 -0200)

are available in the git repository at:
  git://linuxtv.org/jfrancois/gspca.git for_2.6.38

Jean-François Moine (7):
      gspca - sq930x: Don't register a webcam when there are USB errors
      gspca - sq930x: Some detected sensors are not handled yet
      gspca - sq930x: Fix a bad comment
      gspca - main: Check the isoc packet status before its length
      gspca: Use the global error status for get/set streamparm
      gspca - ov519: Bad detection of some ov7670 sensors
      gspca - ov534_9: Remove a useless instruction

Theodore Kilgore (1):
      gspca - sq905c: Adds the Lego Bionicle

 Documentation/video4linux/gspca.txt |    1 +
 drivers/media/video/gspca/gspca.c   |   34 ++++++++++++++++++----------------
 drivers/media/video/gspca/gspca.h   |    2 +-
 drivers/media/video/gspca/ov519.c   |    4 ++--
 drivers/media/video/gspca/ov534.c   |   14 ++------------
 drivers/media/video/gspca/ov534_9.c |    1 -
 drivers/media/video/gspca/sq905c.c  |    1 +
 drivers/media/video/gspca/sq930x.c  |   28 ++++++++++++++++++++--------
 8 files changed, 45 insertions(+), 40 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
