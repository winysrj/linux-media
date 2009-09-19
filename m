Return-path: <linux-media-owner@vger.kernel.org>
Received: from hide1.repubblica.it ([213.92.86.36]:34936 "EHLO
	fo-multiplexor.int.repubblica.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754305AbZISOhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 10:37:10 -0400
Received: from fo-multiplexor.int.repubblica.it (localhost.localdomain [127.0.0.1])
	by postfix.imss70 (Postfix) with ESMTP id AB1D61930073
	for <linux-media@vger.kernel.org>; Sat, 19 Sep 2009 16:05:27 +0200 (CEST)
Received: from mpdomain (co_juniper_ssl.int.repubblica.it [10.151.11.67])
	by fo-multiplexor.int.repubblica.it (Postfix) with ESMTP id 7F412193006F
	for <linux-media@vger.kernel.org>; Sat, 19 Sep 2009 16:05:27 +0200 (CEST)
Message-ID: <4AB4E526.2080109@yahoo.it>
Date: Sat, 19 Sep 2009 16:05:26 +0200
From: Adriano Gigante <adrigiga@yahoo.it>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: driver for Cinergy Hybrid T USB XS FM
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hy all,

after Markus Rechberger has discontinued the development of em28xx-new 
kernel driver, device "Terratec Cinergy Hybrid T USB XS FM" is no more 
supported under linux.
I also built and installed from http://linuxtv.org/hg/v4l-dvb sources 
with no success (it creates /dev/video0 /dev/radio0 /dev/radio1 -no dvb 
- and nothing works).

The device id is 0ccd:0072, and from Terratec site I saw it's based on 
Empia em2882 and Xceive 5000 chips.

Someone could help with infos about this stick

Thanks all people.

Adri
