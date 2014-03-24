Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:57383 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaCXVcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 17:32:41 -0400
Received: by mail-bk0-f43.google.com with SMTP id v15so464bkz.2
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 14:32:40 -0700 (PDT)
Received: from [192.168.1.100] (94.196.240.196.threembb.co.uk. [94.196.240.196])
        by mx.google.com with ESMTPSA id oa10sm15970465bkb.14.2014.03.24.14.32.25
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Mon, 24 Mar 2014 14:32:38 -0700 (PDT)
Message-ID: <1395696718.2999.2.camel@canaries64-MCP7A>
Subject: [PATCH] m88rs2000: fix sparse static warnings.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Mon, 24 Mar 2014 21:31:58 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


warnings
m88rs2000.c:300:16: warning: symbol 'm88rs2000_setup' was not declared. Should it be static?
m88rs2000.c:318:16: warning: symbol 'm88rs2000_shutdown' was not declared. Should it be static?
m88rs2000.c:328:16: warning: symbol 'fe_reset' was not declared. Should it be static?
m88rs2000.c:366:16: warning: symbol 'fe_trigger' was not declared. Should it be static?

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/m88rs2000.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 32cffca..d63bc9c 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -297,7 +297,7 @@ struct inittab {
 	u8 val;
 };
 
-struct inittab m88rs2000_setup[] = {
+static struct inittab m88rs2000_setup[] = {
 	{DEMOD_WRITE, 0x9a, 0x30},
 	{DEMOD_WRITE, 0x00, 0x01},
 	{WRITE_DELAY, 0x19, 0x00},
@@ -315,7 +315,7 @@ struct inittab m88rs2000_setup[] = {
 	{0xff, 0xaa, 0xff}
 };
 
-struct inittab m88rs2000_shutdown[] = {
+static struct inittab m88rs2000_shutdown[] = {
 	{DEMOD_WRITE, 0x9a, 0x30},
 	{DEMOD_WRITE, 0xb0, 0x00},
 	{DEMOD_WRITE, 0xf1, 0x89},
@@ -325,7 +325,7 @@ struct inittab m88rs2000_shutdown[] = {
 	{0xff, 0xaa, 0xff}
 };
 
-struct inittab fe_reset[] = {
+static struct inittab fe_reset[] = {
 	{DEMOD_WRITE, 0x00, 0x01},
 	{DEMOD_WRITE, 0x20, 0x81},
 	{DEMOD_WRITE, 0x21, 0x80},
@@ -363,7 +363,7 @@ struct inittab fe_reset[] = {
 	{0xff, 0xaa, 0xff}
 };
 
-struct inittab fe_trigger[] = {
+static struct inittab fe_trigger[] = {
 	{DEMOD_WRITE, 0x97, 0x04},
 	{DEMOD_WRITE, 0x99, 0x77},
 	{DEMOD_WRITE, 0x9b, 0x64},
-- 
1.9.1

