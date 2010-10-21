Return-path: <mchehab@pedra>
Received: from thingy.pointless.net ([91.209.244.43]:60566 "EHLO
	thingy.pointless.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0JUBXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 21:23:16 -0400
Received: from [93.89.81.29] (port=13951 helo=limpit.local)
	by thingy.pointless.net with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.71)
	(envelope-from <jasper@pointless.net>)
	id 1P8jUj-0005kw-CV
	for linux-media@vger.kernel.org; Thu, 21 Oct 2010 01:59:01 +0100
Date: Thu, 21 Oct 2010 01:59:00 +0100 (BST)
From: Jasper Wallace <jasper@pointless.net>
To: linux-media@vger.kernel.org
Subject: em28xx: new board id [1b80:e349]
Message-ID: <alpine.DEB.2.00.1010210153130.4519@yvzcvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hi, 

I've made tests with my Magix "RESCUE YOUR VIDEOTAPES!" usb dongle, this 
device looks identical to the pictures of the Kaiser Baas USB DVD Maker 2 
(KBA0300300) on the wiki:

Model: Magix RESCUE YOUR VIDEOTAPES!
Vendor/Product id: [1b80:e349].

Tests made: 

    - Analog [Worked, only tested PAL]
    - DVB    [this board doesn't support dvb mode]

Tested-by: Jasper <jasper@pointless.net>

-- 
[http://pointless.net/]                                   [0x2ECA0975]
