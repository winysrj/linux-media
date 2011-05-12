Return-path: <mchehab@gaivota>
Received: from cmsout02.mbox.net ([165.212.64.32]:52345 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932580Ab1ELU3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 16:29:40 -0400
Received: from cmsout02.mbox.net (co02-lo [127.0.0.1])
	by cmsout02.mbox.net (Postfix) with ESMTP id 086511343A9
	for <linux-media@vger.kernel.org>; Thu, 12 May 2011 20:29:39 +0000 (GMT)
Message-ID: <4DCC4304.2020205@usa.net>
Date: Thu, 12 May 2011 22:28:52 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: ngene CI problems
References: <4D74E28A.6030302@gmail.com> <201105112059.21083@orion.escape-edv.de>
In-Reply-To: <201105112059.21083@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 11/05/11 20:59, Oliver Endriss wrote:
>
> I reworked the driver to strip those null packets. Please try
> http://linuxtv.org/hg/~endriss/ngene-octopus-test/raw-rev/f0dc4237ad08
>
> CU
> Oliver
>

Hi Oliver,

Tried your patch, but FFs have been replaced by 6Fs in null packets.
Other than that, no improvement for me.

Thx
--
Issa
