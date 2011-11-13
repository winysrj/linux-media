Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:58467 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1KMOuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 09:50:18 -0500
Received: from [79.254.116.208] (helo=hana.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <gusto@guttok.net>)
	id 1RPbNu-0006yj-IQ
	for linux-media@vger.kernel.org; Sun, 13 Nov 2011 15:50:15 +0100
Date: Sun, 13 Nov 2011 15:49:12 +0100
From: Lars Schotte <gusto@guttok.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: HVR900H works with kernel 3.2 to me
Message-ID: <20111113154912.63a6234a@hana.gusto>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

i can confirm, that hvr900h works with 3.2 to me. it doesnt kill the
whole usb subsystem after two repluggings... however i am not sure if
it is the device or its an another problem, kernel 3.2 doesnt
suspend-to-ram ... it crashes.

-- 
Lars Schotte
@ Hana (F16)
