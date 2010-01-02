Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:41838 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab0ABRjL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jan 2010 12:39:11 -0500
Received: from kabelnet-196-226.juropnet.hu ([91.147.196.226])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NR7E2-0005Qh-0a
	for linux-media@vger.kernel.org; Sat, 02 Jan 2010 17:53:16 +0100
Message-ID: <4B3F7B0D.4030601@mailbox.hu>
Date: Sat, 02 Jan 2010 17:57:49 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net>
In-Reply-To: <4B3F6FE0.4040307@internode.on.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/02/2010 05:10 PM, Raena Lea-Shannon wrote:

> I have 2 TV Cards. The DTV2000 H Plus and a Technisat. The Technisat
> works very well. I am trying to get the DVT working for other video
> input devices such as VCR to make copies of old Videos and an inteface
> for my N95 video out.
> 
> I do not seem to be able to get it to find a tuner. Seems to be problem
> finding the card. Any suggestions wold be greatly appreciated.

This card uses an Xceive XC4000 tuner, which is not supported yet.
However, a driver for the tuner chip is being developed at
kernellabs.com, so the card may become supported in the future.
