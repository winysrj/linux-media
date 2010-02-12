Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:35070 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab0BLSa1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 13:30:27 -0500
Received: from kabelnet-194-166.juropnet.hu ([91.147.194.166])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1Ng0Eu-0005at-If
	for linux-media@vger.kernel.org; Fri, 12 Feb 2010 19:27:45 +0100
Message-ID: <4B759F1F.4000907@mailbox.hu>
Date: Fri, 12 Feb 2010 19:34:07 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu> <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu> <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu> <4B759D44.6090100@mailbox.hu>
In-Reply-To: <4B759D44.6090100@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A correction to the previous post: this line:
		if (WaitForLock(priv) == 0)
should actually be:
		if (WaitForLock(priv) != 1)
It does not have an effect on the operation of the driver, though,
since the value set depending on this line is not used.
