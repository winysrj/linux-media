Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:36975 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbZJDLiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 07:38:00 -0400
Received: by ewy7 with SMTP id 7so2693202ewy.17
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 04:37:23 -0700 (PDT)
Message-ID: <4AC88895.2040601@tremplin-utc.net>
Date: Sun, 04 Oct 2009 13:35:49 +0200
From: "=?ISO-8859-1?Q?=C9ric_Piel?=" <eric.piel@tremplin-utc.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	Uri Shkolnik <uris@siano-ms.com>, linux-media@vger.kernel.org
Subject: [PATCH] sms1xxx: load smsdvb also for the hauppauge tiger cards
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here is a patch to get my DVB-T receiver directly being recognized useful.
It's against Linus' 2.6.32-rc1.

Eric

==

I've got a hauppauge tiger minicard (2040:2011), and without smsdvb loaded,
it's completely useless (to watch TV). So let's add both the minicard and the
minicard r2 to the list of cards which should trigger the load of smsdvb.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
  drivers/media/dvb/siano/sms-cards.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
index 0420e28..e216389 100644
--- a/drivers/media/dvb/siano/sms-cards.c
+++ b/drivers/media/dvb/siano/sms-cards.c
@@ -294,6 +294,8 @@ int sms_board_load_modules(int id)
  	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
  	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
  	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
+	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
  		request_module("smsdvb");
  		break;
  	default:
