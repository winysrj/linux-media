Return-path: <mchehab@gaivota>
Received: from cmsout02.mbox.net ([165.212.64.32]:48661 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab1EKQNE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2011 12:13:04 -0400
Received: from cmsout02.mbox.net (co02-lo [127.0.0.1])
	by cmsout02.mbox.net (Postfix) with ESMTP id 51F0C134584
	for <linux-media@vger.kernel.org>; Wed, 11 May 2011 13:22:08 +0000 (GMT)
Date: Wed, 11 May 2011 15:22:04 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: <linux-media@vger.kernel.org>
Subject: dvb demux: isolating the pids related to a scrambled channel
Mime-Version: 1.0
Message-ID: <677PekNVe3040S04.1305120124@web04.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

To decramble a channel with a ngene based card, you either need to:

1) send the full ts to sec0;

2) send a filtered ts to sec0.

The latter case shall permit the descrambling of 2 channels transmitted from 2
different ts/tuners.

I'm interested in knowing how to do this: filter a ts so that I only keep the
needed pids for the cam.

Can anyone help ?

Thx
--
Issa

