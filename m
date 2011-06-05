Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:54873 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab1FEOao (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Jun 2011 10:30:44 -0400
Received: from [94.248.226.13]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QTELg-0001cJ-7R
	for linux-media@vger.kernel.org; Sun, 05 Jun 2011 16:30:42 +0200
Message-ID: <4DEB930F.3020504@mailbox.hu>
Date: Sun, 05 Jun 2011 16:30:39 +0200
From: Istvan Varga <istvan_v@mailbox.hu>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: XC4000: setting registers
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com> <4DEA4B6A.70602@mailbox.hu> <4DEB710B.4090704@redhat.com> <4DEB766D.4040509@mailbox.hu> <4DEB7CEC.9090305@redhat.com>
In-Reply-To: <4DEB7CEC.9090305@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/05/2011 02:56 PM, Mauro Carvalho Chehab wrote:

> Ok, just pushed it (I forgot to use the -f tag). Please double check
> if the code is working on the devices you have.

I did not try building it, but the code now seems to be identical to the
xc4000.c/h driver I am currently using. There is one minor difference:
at line 1446, the use of the 'type' variable is still commented out; it
does not actually affect the operation of the driver, though, since the
NOGD bit is currently never set.
