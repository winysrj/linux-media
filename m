Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1009.centrum.cz ([90.183.38.139]:34636 "EHLO
	mail1009.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978AbZDFUkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 16:40:53 -0400
Received: by mail1009.centrum.cz id S738251264AbZDFUki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 22:40:38 +0200
Date: Mon, 06 Apr 2009 22:40:38 +0200
From: "Miroslav =?UTF-8?Q?=20=C5=A0ustek?=" <sustmidown@centrum.cz>
To: <linux-media@vger.kernel.org>
Cc: <cus@fazekas.hu>, <mchehab@redhat.com>
MIME-Version: 1.0
Message-ID: <200904062240.1773@centrum.cz>
References: <200904062233.30966@centrum.cz> <200904062234.8192@centrum.cz> <200904062235.15206@centrum.cz> <200904062236.31983@centrum.cz> <200904062237.27161@centrum.cz> <200904062238.10335@centrum.cz> <200904062239.877@centrum.cz> <200904062240.9520@centrum.cz>
In-Reply-To: <200904062240.9520@centrum.cz>
Subject: cx88-dsp.c: missing __divdi3 on 32bit kernel
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
Commit 02fde69f31dc (and 7152a23142bc) on http://linuxtv.org/hg/v4l-dvb/
adds new file cx88-dsp.c which uses 64bit divisions, but these are somehow
not supported on 32bit kernels.

message during compile:
WARNING: "__divdi3" [/root/v4l-dvb/v4l/cx88xx.ko] undefined

Maybe we can use only s32, but I don't know if it's precise enough for that magic math.
Or use some ugly hacks to do 64bit division with 32bit variables.

What hardware do I need to test the cx88-dsp code?

Any suggestions?

- Miroslav

