Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:47715 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0CVS1y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 14:27:54 -0400
Received: from kabelnet-199-249.juropnet.hu ([91.147.199.249])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NtmLu-0002JO-UF
	for linux-media@vger.kernel.org; Mon, 22 Mar 2010 19:27:53 +0100
Message-ID: <4BA7B7FE.9040100@mailbox.hu>
Date: Mon, 22 Mar 2010 19:33:34 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B463AC6.2000901@mailbox.hu>	 <4B719CD0.6060804@mailbox.hu> <4B745781.2020408@mailbox.hu>	 <4B7C303B.2040807@mailbox.hu> <4B7C80F5.5060405@redhat.com>	 <829197381002171559k10b692dcu99a3adc2f613437f@mail.gmail.com>	 <4B7C84F3.4080708@redhat.com>	 <829197381002171611u7fcc8caeuea98e047164ae55@mail.gmail.com>	 <4B9D23DD.8080401@mailbox.hu> <829197381003142115v6b10a328n30eadeef64b87c8@mail.gmail.com>
In-Reply-To: <829197381003142115v6b10a328n30eadeef64b87c8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/15/2010 05:15 AM, Devin Heitmueller wrote:

> I'll try to go through my tree and see if I can get something upstream
> this week which you could build on.

Are there any news on this ?

By the way, I have just received this mail from Mirek Slugen, with a
patch for PxDVR3200 with XC4000 tuner. Should that patch also be
submitted ?

On 03/22/2010 04:40 PM, Mirek Slugeň wrote:

> First I would like to thank you for your work on XC4000 Leadtek
> tuners, analog TV, analog FM and DVB-T works great.
>
> I created patch for new revision of Leadtek DVR3200 (xc4000) based on
> your patch and it works also (patch is included).
>
> After long testing I found only one small bug, signal strength is not
> working on DVB-T XC4000 based tuners, so i will try to fix it.
