Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36247 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2F3Edw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 00:33:52 -0400
Received: by wibhr14 with SMTP id hr14so1529286wib.1
        for <linux-media@vger.kernel.org>; Fri, 29 Jun 2012 21:33:50 -0700 (PDT)
Subject: stb0899: fix not locking DVB-S transponder
From: walou <walou.media@gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5E4D14A9-9C7C-4DDC-BC05-130341396E66@gmail.com>
Date: Sat, 30 Jun 2012 05:34:12 +0100
To: linux-media <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (1.0)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is the patch below still necessary to make the skystar HD2 working correctly ?

https://patchwork.kernel.org/patch/753382/