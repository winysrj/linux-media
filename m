Return-path: <mchehab@gaivota>
Received: from ns1.baycom.de ([109.125.67.67]:44732 "EHLO mail.baycom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab0L2LzP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 06:55:15 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.baycom.de (Postfix) with ESMTP id 4D53C4207D
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 12:55:14 +0100 (CET)
Received: from mail.baycom.de ([127.0.0.1])
	by localhost (mx.baycom.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YcdVa4W1KjCj for <linux-media@vger.kernel.org>;
	Wed, 29 Dec 2010 12:55:11 +0100 (CET)
Received: from mac.baycom.de (unknown [IPv6:2001:4c50:fffe:4:223:6cff:fe89:d345])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: fliegl)
	by mail.baycom.de (Postfix) with ESMTPSA id 9898941216
	for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 12:55:11 +0100 (CET)
Message-ID: <4D1B219F.6010600@fliegl.de>
Date: Wed, 29 Dec 2010 12:55:11 +0100
From: Deti Fliegl <deti@fliegl.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] dabusb: Move it to staging to be deprecated
References: <4D19037B.6060904@redhat.com>	<AANLkTi=MFVH0b8y7eneaku9sf5x5ZWWiZBK+5Bptx6cE@mail.gmail.com>	<201012291137.49153.hverkuil@xs4all.nl> <AANLkTi=oSzDjBAvJ9y6Z-+AkTjaEVZsCGv=Rsui0f55k@mail.gmail.com>
In-Reply-To: <AANLkTi=oSzDjBAvJ9y6Z-+AkTjaEVZsCGv=Rsui0f55k@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/29/10 12:39 PM, Manu Abraham wrote:
> Quite unlikely that you need to design a new API for it.
>
> The ETSI DAB page says:
Every DAB receiver delivers some format different from a regular 
transport stream. The most common streaming format is RDI (EN 50255). 
The communication with the receiver is not standardized and differs in 
many ways. I think the problem will be to have a free software stack 
that decodes every service (FIC, MSC, dynamic labels, MOT, etc.) - It 
will be really a lot of work for a system that is dead now.

Deti
