Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46111 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaBSOyO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 09:54:14 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1WG8XI-0006wN-80
	for linux-media@vger.kernel.org; Wed, 19 Feb 2014 15:54:08 +0100
Received: from exchange.muehlbauer.de ([194.25.158.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 19 Feb 2014 15:54:08 +0100
Received: from Bassai_Dai by exchange.muehlbauer.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 19 Feb 2014 15:54:08 +0100
To: linux-media@vger.kernel.org
From: Tom <Bassai_Dai@gmx.net>
Subject: ti codec engine
Date: Wed, 19 Feb 2014 14:53:31 +0000 (UTC)
Message-ID: <loom.20140219T154843-998@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm using dm3730 processor along with a ov3640 camera sensor. I'm working
with the ti-dvsdk_dm3730-evm_04_03_00_06 and the appropriate 2.6.37 linux
kernel. With a working camera driver I'm able to grab images and store them
to memory. My goal is to use some kind of a image processing algorithm on
the dsp with the image I stored in memory. So for that I read that the sdk
provides the dsplink, the cmem, the lpm driver and on top of that the codec
engine to work with the dsp. Are there already some tutorials or examples
which matches my task? 

Does anyone have some experience with the codec engine from ti?

Best Regards, Tom


