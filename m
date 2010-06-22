Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.vigard.cz ([78.24.9.173]:41183 "EHLO mail.vigard.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314Ab0FVKil (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jun 2010 06:38:41 -0400
Received: from [10.10.10.5] (216.191.broadband13.iol.cz [90.180.191.216])
	(Authenticated sender: ld)
	by mail.vigard.cz (Postfix) with ESMTPSA id B4FE29DCAF
	for <linux-media@vger.kernel.org>; Tue, 22 Jun 2010 12:28:48 +0200 (CEST)
Message-ID: <4C209063.7080504@dolezel.info>
Date: Tue, 22 Jun 2010 12:28:51 +0200
From: =?ISO-8859-2?Q?Lubo=B9_Dole=BEel?= <lubos@dolezel.info>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Support for 0ccd:0072 in em28xx?
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a Terratec Cinergy XS Hybrid card [0ccd:0072] that used to be 
supported by the em28xx-new driver. The project has since been 
discontinued and the source code is unmaintained and incompatible with 
current kernels.

Happens anyone to be working on supporting my model in the in-kernel 
em28xx? It seems my card is based on xc5000, which the current code 
doesn't take in to account :-(

I don't care about analog/FM that much, DVB-T is what matters the most.

Please CC me in response!

Thanks,
best regards,
--
Lubo¹ Dole¾el
