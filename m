Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:45728 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0ADQp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 11:45:59 -0500
Received: from kabelnet-194-222.juropnet.hu ([91.147.194.222])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NRq1i-0004E4-TE
	for linux-media@vger.kernel.org; Mon, 04 Jan 2010 17:43:33 +0100
Message-ID: <4B421BCB.6050909@mailbox.hu>
Date: Mon, 04 Jan 2010 17:48:11 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net>
In-Reply-To: <4B405381.9090407@internode.on.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/03/2010 09:21 AM, Raena Lea-Shannon wrote:

> That seems odd. This patch on the LinuxTv site
> http://www.linuxtv.org/pipermail/linux-dvb/2008-June/026379.html
> seems to be using the cx88 drivers?

Unfortunately, this patch is for the older DTV 2000H (not Plus)
card, which uses a Philips FMD1216 tuner. The main change on the
"Plus" card is the replacement of the tuner with the XC4000, and
that is why it is not supported yet. However, an XC4000 driver
is already under development, and - compiling V4L from source -
you could get the card working in the near future. In fact, code
that implements support for this card already exists, but it is
only for development/testing at the moment.
