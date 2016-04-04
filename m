Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:33201 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbcDDMxd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2016 08:53:33 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
	by ni.piap.pl (Postfix) with ESMTP id 6A31744132D
	for <linux-media@vger.kernel.org>; Mon,  4 Apr 2016 14:53:29 +0200 (CEST)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media@vger.kernel.org
Subject: Non-coherent (streaming) contig-dma?
Date: Mon, 04 Apr 2016 14:53:29 +0200
Message-ID: <m3r3elh6wm.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I know certain approaches had been tried to allow use of streaming DMA
(dma_map_single() etc. - i.e., not coherent) in the media drivers, is
there something which can be used at this point (for MMAP method)?

Coherent buffers on many systems are very slow (uncacheable), should
i simply add/replace the necessary calls in dma-contig?

Any other options?

Is there any potential problem there?
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
