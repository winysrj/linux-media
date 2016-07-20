Return-path: <linux-media-owner@vger.kernel.org>
Received: from queue01c.mail.zen.net.uk ([212.23.3.237]:50931 "EHLO
	queue01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbcGTKLY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 06:11:24 -0400
Received: from [212.23.1.23] (helo=smarthost03d.mail.zen.net.uk)
	by queue01c.mail.zen.net.uk with esmtp (Exim 4.72)
	(envelope-from <martin@luminoussheep.net>)
	id 1bPoCq-0003jN-IP
	for linux-media@vger.kernel.org; Wed, 20 Jul 2016 09:54:20 +0000
Received: from [82.68.240.77] (helo=ghost)
	by smarthost03d.mail.zen.net.uk with esmtps (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <martin@luminoussheep.net>)
	id 1bPoCR-0005WO-1M
	for linux-media@vger.kernel.org; Wed, 20 Jul 2016 09:53:55 +0000
Received: from localhost ([::1] helo=luminoussheep.net)
	by ghost with esmtp (Exim 4.84_2)
	(envelope-from <martin@luminoussheep.net>)
	id 1bPoCe-0008IC-5P
	for linux-media@vger.kernel.org; Wed, 20 Jul 2016 10:54:08 +0100
Message-ID: <e3148010250e01b8f1fde94c584ab36e.squirrel@luminoussheep.net>
Date: Wed, 20 Jul 2016 10:54:08 +0100
Subject: em288xx and lna - how to enable?
From: "Martin" <martin@luminoussheep.net>
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I see that my card 292e has LNA support:
https://patchwork.linuxtv.org/patch/23763/

but searching I can't find how to enable this the force option
force_lna_activation=1 that the t500 uses isn't recognised

Please could someone tell me if this is configurable an if so how to
configure it?

Thanks,
M

