Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd16922.kasserver.com ([85.13.137.202]:45750 "EHLO
	dd16922.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0FGL1q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jun 2010 07:27:46 -0400
Received: from dd16922.kasserver.com (kasmail1.kasserver.com [85.13.137.172])
	by dd16922.kasserver.com (Postfix) with SMTP id 7B3B010FC20F
	for <linux-media@vger.kernel.org>; Mon,  7 Jun 2010 13:27:44 +0200 (CEST)
Subject: v4l-dvb - Is it still usable for a distribution ?
from: vdr@helmutauer.de
to: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20100607112744.7B3B010FC20F@dd16922.kasserver.com>
Date: Mon,  7 Jun 2010 13:27:44 +0200 (CEST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello List,

I have a Gentoo based VDR Distribution named Gen2VDR.
As the name said its main application is VDR.
Until kernel 2.6.33 I bundled the v4l-dvb drivers emerged via the gentoo ebuild with my distribution.
Now with kernel 2.6.34 this doesn't work anymore, because v4l-dvb doesn't compile.
Another problem (after fixing the compile issues) is the IR Part of v4l-dvb which includes an Imon module.
This module doesn't provide any lirc devices, so how can this oe be used as an IR device ?
Til now I am using lirc_imon which fit all my needs.

The final question for me:
Does it make any sense anymore to stay with v4l-dvb or do I have to change to the kernel drivers ?
The major disadvantage of the kernel drivers is the fact that I cannot switch to newer dvb drivers, I am stuck to the ones included in the kernel.

Any comments are very welcome

Helmut Auer



