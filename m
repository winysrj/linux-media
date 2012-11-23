Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3371 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab2KWL0I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 06:26:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/15] MAINTAINERS: add radio-isa entry.
Date: Fri, 23 Nov 2012 12:25:47 +0100
Message-Id: <cdaf306b94ebf241dcbc58b17d5fdf7286292f0c.1353669806.git.hans.verkuil@cisco.com>
In-Reply-To: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
References: <1353669956-4843-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
References: <7fb3123c4bf43540c13505c82c408fa492cdd48c.1353669806.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2eb2951..ebacbd5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4126,6 +4126,14 @@ F:	Documentation/isapnp.txt
 F:	drivers/pnp/isapnp/
 F:	include/linux/isapnp.h
 
+ISA RADIO MODULE
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Maintained
+F:	drivers/media/radio/radio-isa*
+
 iSCSI BOOT FIRMWARE TABLE (iBFT) DRIVER
 M:	Peter Jones <pjones@redhat.com>
 M:	Konrad Rzeszutek Wilk <konrad@kernel.org>
-- 
1.7.10.4

