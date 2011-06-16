Return-path: <mchehab@pedra>
Received: from r02s01.colo.vollmar.net ([83.151.24.194]:36982 "EHLO
	holzeisen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1FPIZz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 04:25:55 -0400
Received: from [10.7.0.10] (unknown [10.7.0.10])
	by holzeisen.de (Postfix) with ESMTPA id 68B59807C37C
	for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 10:19:58 +0200 (CEST)
Message-ID: <4DF9BCAA.3030301@holzeisen.de>
Date: Thu, 16 Jun 2011 10:19:54 +0200
From: Thomas Holzeisen <thomas@holzeisen.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: RTL2831U wont compile against 2.6.38
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi there,

I tried to get an RTL2831U dvb-t usb-stick running with a more recent kernel (2.6.38) and failed.

The hg respository ~jhoogenraad/rtl2831-r2 aborts on countless drivers, the rc coding seem have to
changed a lot since it got touched the last time.

The hg respository ~anttip/rtl2831u wont compile as well, since its even older.

The recent git respositories for media_tree and anttip dont contain drivers for the rtl2831u.

Has this device been abandoned, or is anyone working on it?

greetings,
Thomas
