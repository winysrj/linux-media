Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:38715 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab0CNRxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 13:53:42 -0400
Received: from kabelnet-193-38.juropnet.hu ([91.147.193.38])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1Nqs0N-0005Be-JP
	for linux-media@vger.kernel.org; Sun, 14 Mar 2010 18:53:41 +0100
Message-ID: <4B9D23DD.8080401@mailbox.hu>
Date: Sun, 14 Mar 2010 18:58:53 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B421BCB.6050909@mailbox.hu>	 <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com>	 <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>	 <4B7C84F3.4080708@redhat.com> <829197381002171611u7fcc8caeuea98e047164ae55@mail.gmail.com>
In-Reply-To: <829197381002171611u7fcc8caeuea98e047164ae55@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2010 01:11 AM, Devin Heitmueller wrote:

> Yeah, my plan at this point was to submit a PULL request once I felt
> the driver is stable

For those particular cards that my patch adds support for, it seems to
be stable, and I have been using it for months. Perhaps stability issues
in xc4000.c are specific to the PCTV 340e and its dib0700 I2C problems ?
