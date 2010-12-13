Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:32910 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab0LMNAc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:00:32 -0500
Date: Mon, 13 Dec 2010 14:02:29 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/6] gspca sonixj better handling of reg 01 and 17
Message-ID: <20101213140229.6379b78d@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Here is an other way to fix the inv powerdown bug.

These patches are not tested yet.

Jean-François Moine (6):
      gspca - sonixj: Move bridge init to sd start
      gspca - sonixj: Fix a bad probe exchange
      gspca - sonixj: Add a flag in the driver_info table
      gspca - sonixj: Set the flag for some devices
      gspca - sonixj: Add the bit definitions of the bridge reg 0x01 and 0x17
      gspca - sonixj: Better handling of the bridge registers 0x01 and 0x17

 drivers/media/video/gspca/sonixj.c |  410 ++++++++++++++++--------------------
 1 files changed, 182 insertions(+), 228 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
