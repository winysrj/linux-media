Return-path: <linux-media-owner@vger.kernel.org>
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:37177 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751741Ab3EJHt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 03:49:29 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, mchehab@redhat.com,
	ezequiel.garcia@free-electrons.com, jonarne@jonarne.no
Subject: [PATCH V1 0/1] saa7115: Add register setup for gm7113c
Date: Fri, 10 May 2013 09:52:27 +0200
Message-Id: <1368172348-8459-1-git-send-email-jonarne@jonarne.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch will make the saa7115 driver work with the
stk1160 and smi2021 devices.

This is an extension to the patches posted by Mauro here:
https://patchwork.linuxtv.org/patch/18233/
https://patchwork.linuxtv.org/patch/18232/

This patch along with the two patches posted by Mauro should
probably supersede the patches posted by me here:
https://patchwork.linuxtv.org/patch/18291/
https://patchwork.linuxtv.org/patch/18290/
https://patchwork.linuxtv.org/patch/18289/

Jon Arne Jørgensen (1):
  saa7115: Add register setup and config for gm7113c

 drivers/media/i2c/saa7115.c | 47 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

-- 
1.8.2.1

