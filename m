Return-path: <mchehab@pedra>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:48799 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0IHK2n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 06:28:43 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by stevekerrison.com (Postfix) with ESMTP id 68CF210200D
	for <linux-media@vger.kernel.org>; Wed,  8 Sep 2010 11:28:42 +0100 (BST)
Received: from stevekerrison.com ([127.0.0.1])
	by localhost (stevekez.vm.bytemark.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X6XTOFoSTvd8 for <linux-media@vger.kernel.org>;
	Wed,  8 Sep 2010 11:28:34 +0100 (BST)
Received: from [192.168.1.10] (94-193-106-123.zone7.bethere.co.uk [94.193.106.123])
	(Authenticated sender: steve@stevekerrison.com)
	by stevekerrison.com (Postfix) with ESMTPSA id D62EA8A019
	for <linux-media@vger.kernel.org>; Wed,  8 Sep 2010 11:28:34 +0100 (BST)
Subject: First DVB-T2 tuner announced - Hauppauge PCTV Nanostick T2 290e
From: Steve Kerrison <steve@stevekerrison.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Sep 2010 11:28:34 +0100
Message-ID: <1283941714.3425.17.camel@goliath-lin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hauppauge has released details of its first DVB-T2 tuner at IFA. Some
scarce details are here:

http://www.wegotserved.com/2010/09/04/ifa-2010-hauppauge-announces-freeview-hd-dvbt2-tuner-pc/

along with a "datasheet" (without very much data) here:

http://www.wegotserved.com/2010/09/06/ifa-2010-pctv-nanostick-t2-290e-freeview-hd-tuner-full-specs-data-sheet/

Only 720p video support is claimed, but that can't be anything to do
with receiving the mux so I suspect that's a software limitation in the
bundled player.

Does anyone have (or have a means of getting) more info on the internals
of this stick to aid Linux development? I will be attempting to acquire
one of these at first release in October, and will do what I can, from
USB snooping through to module development - as far as my time and skill
can muster.

Regards,
Steve Kerrison.

