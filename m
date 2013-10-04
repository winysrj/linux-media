Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3467 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3JDOCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Oct 2013 10:02:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/14] az6027: fix sparse warnings
Date: Fri,  4 Oct 2013 16:01:48 +0200
Message-Id: <1380895312-30863-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
References: <1380895312-30863-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/usb/dvb-usb/az6027.c:257:23: warning: symbol 'az6027_stb0899_config' was not declared. Should it be static?
drivers/media/usb/dvb-usb/az6027.c:294:23: warning: symbol 'az6027_stb6100_config' was not declared. Should it be static?

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb/az6027.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index ea2d5ee..c11138e 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -254,7 +254,7 @@ static const struct stb0899_s1_reg az6027_stb0899_s1_init_3[] = {
 
 
 
-struct stb0899_config az6027_stb0899_config = {
+static struct stb0899_config az6027_stb0899_config = {
 	.init_dev		= az6027_stb0899_s1_init_1,
 	.init_s2_demod		= stb0899_s2_init_2,
 	.init_s1_demod		= az6027_stb0899_s1_init_3,
@@ -291,7 +291,7 @@ struct stb0899_config az6027_stb0899_config = {
 	.tuner_set_rfsiggain	= NULL,
 };
 
-struct stb6100_config az6027_stb6100_config = {
+static struct stb6100_config az6027_stb6100_config = {
 	.tuner_address	= 0xc0,
 	.refclock	= 27000000,
 };
-- 
1.8.3.2

