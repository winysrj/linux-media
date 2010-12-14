Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:45041 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0LNTLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 14:11:02 -0500
Date: Tue, 14 Dec 2010 20:13:04 +0100
From: =?UTF-8?B?SmVhbi1GcmFuw6dvaXM=?= Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 0/6] gspca sonixj better handling of reg 01 and 17
Message-ID: <20101214201304.2bf85295@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Here is a new version following Mauro's remarks and with some fixes.

Jean-François Moine (6):
      gspca - sonixj: Move bridge init to sd start
      gspca - sonixj: Fix a bad probe exchange
      gspca - sonixj: Add a flag in the driver_info table
      gspca - sonixj: Set the flag for some devices
      gspca - sonixj: Add the bit definitions of the bridge reg 0x01 and 0x17
      gspca - sonixj: Better handling of the bridge registers 0x01 and 0x17

 drivers/media/video/gspca/sonixj.c |  416 ++++++++++++++++--------------------
 1 files changed, 184 insertions(+), 232 deletions(-)
