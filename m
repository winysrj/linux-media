Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:47889 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1FIVPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 17:15:53 -0400
Received: from [94.248.227.62] (helo=linux-mrjj.localnet)
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QUmZv-0002Xa-9H
	for linux-media@vger.kernel.org; Thu, 09 Jun 2011 23:15:50 +0200
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] XC4000: removed card_type
From: Istvan Varga <istvan_v@mailbox.hu>
Date: Thu, 9 Jun 2011 23:15:46 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106092315.46499.istvan_v@mailbox.hu>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 06 June 2011 22:10:22 you wrote:

> Please solve the firmware issue before the next merge window.

I have already received the Xceive firmware source and the program that
builds the firmware for the Linux driver from Devin Heitmueller, and
have sent back to him a modified version that builds the complete
firmware (including the analog standards) yesterday. If this version
does not have bugs, the firmware should be available soon.
