Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:42285 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbZCDKgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 05:36:32 -0500
Received: from mail01.m-online.net (mail.m-online.net [192.168.3.149])
	by mail-out.m-online.net (Postfix) with ESMTP id 208811C0209F
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2009 11:36:31 +0100 (CET)
Received: from localhost (dynscan2.mnet-online.de [192.168.1.215])
	by mail.m-online.net (Postfix) with ESMTP id 2CC8B90069
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2009 11:36:30 +0100 (CET)
Received: from mail.mnet-online.de ([192.168.3.149])
	by localhost (dynscan2.mnet-online.de [192.168.1.215]) (amavisd-new, port 10024)
	with ESMTP id fvAWKp5pHWGh for <linux-media@vger.kernel.org>;
	Wed,  4 Mar 2009 11:36:29 +0100 (CET)
Received: from gauss.x.fun (ppp-88-217-126-229.dynamic.mnet-online.de [88.217.126.229])
	by mail.nefkom.net (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2009 11:36:29 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by gauss.x.fun (Postfix) with ESMTP id B8C891D4371
	for <linux-media@vger.kernel.org>; Wed,  4 Mar 2009 11:36:28 +0100 (CET)
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: Cleanup of dvb frontend driver header files
Date: Wed, 4 Mar 2009 11:36:26 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903041136.27283.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there!

While having a look at lnbp21.h I have seen it includes <linux/dvb/frontend.h> 
without needing it. (There are only pointers referring to struct 
dvb_frontend).

So I had a look at the whole directory.
# cd linux/drivers/media/dvb/frontends
# grep -l linux/dvb/frontend.h *.h|wc -l
47

So 47 header files include this header and seem not to need it.
At least removing this line still allows me to compile the full set of v4l-dvb 
drivers.
# sed -e '/linux\/dvb\/frontend/s-^-// -' -i *.h

Some of these files use more headers the same way like dvb_frontend.h, 
firmware.h or i2c.h

Is this kind of cleanup appreciated, or should the includes be kept even if 
they are not really needed for pointers to structs like dvb_frontend.

Regards
Matthias
