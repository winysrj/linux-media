Return-path: <mchehab@pedra>
Received: from cmsout01.mbox.net ([165.212.64.31]:33980 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1CPWHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 18:07:36 -0400
Received: from cmsout01.mbox.net (cmsout01-lo [127.0.0.1])
	by cmsout01.mbox.net (Postfix) with ESMTP id 3127A2ACB15
	for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 22:07:35 +0000 (GMT)
Message-ID: <4D81348D.2070803@usa.net>
Date: Wed, 16 Mar 2011 23:07:09 +0100
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home> <4D7A97BB.4020704@gmail.com> <4D7B7524.2050108@linuxtv.org> <201103130042.49199@orion.escape-edv.de> <4D7CA0CC.8090308@gmail.com>
In-Reply-To: <4D7CA0CC.8090308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 13/03/11 11:47, Martin Vidovic wrote:
>>
>> Btw, we should choose a more meaningful name for 'camX'.
>> I would prefer something like cainoutX or caioX or cinoutX or cioX.
>>   
>
>
> I agree, camX could be misleading since it's not necessarily a CAM
> application.
>
> According to EN 50221 the two interfaces are named Command Interface
> (for caX)
> and Transport Stream Interface (for camX). Then maybe 'tsiX' would be
> an appropriate
> name?
>
> Anyway, 'cioX' sounds good too.

I'll prepare the patch with caio (for conditional access I/O) if all
agrees on it. tsi is a good candidate as it perfectly matches the
standard specification, but then, ca should have been ci...

--
Issa
