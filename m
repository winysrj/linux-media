Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1008.centrum.cz ([90.183.38.138]:35067 "EHLO
	mail1008.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906AbZE2OdA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 10:33:00 -0400
Received: by mail1008.centrum.cz id S939615179AbZE2Oc7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 16:32:59 +0200
Date: Fri, 29 May 2009 16:32:59 +0200
From: "Miroslav =?UTF-8?Q?=20=C5=A0ustek?=" <sustmidown@centrum.cz>
To: <linux-media@vger.kernel.org>
Cc: <mchehab@infradead.org>
MIME-Version: 1.0
Message-ID: <200905291632.28450@centrum.cz>
References: <200905291628.32305@centrum.cz> <200905291629.364@centrum.cz> <200905291630.21607@centrum.cz> <200905291631.1309@centrum.cz> <200905291632.13608@centrum.cz>
In-Reply-To: <200905291632.13608@centrum.cz>
Subject: [PATCH] Leadtek WinFast DTV-1800H support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
this patch adds support for Leadtek WinFast DTV-1800H hybrid card.
It enables analog/digital tv, radio and remote control trough GPIO.

Input GPIO values are extracted from INF file which is included in winxp driver.
Analog audio works both through cx88-alsa and through internal cable from tv-card to sound card.

Tested by me and the people listed in patch (works well).

- Miroslav Šustek

(Sorry for double-post, but I was told to do it so. Nobody noticed the previous post(s).)

