Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:46453 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZLBAcE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Dec 2009 19:32:04 -0500
Received: from epmmp2 (mailout3.samsung.com [203.254.224.33])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KU0002A01HK3W@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2009 09:32:08 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KU000D8B1HK2P@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Dec 2009 09:32:09 +0900 (KST)
Date: Wed, 02 Dec 2009 09:32:09 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH 1/3] radio-si470x: fix SYSCONFIG1 register set on
 si470x_start()
In-reply-to: <200912020112.59668.tobias.lorenz@gmx.net>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kyungmin.park@samsung.com
Message-id: <4B15B589.2020805@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4B039265.1020906@samsung.com>
 <200912020039.02737.tobias.lorenz@gmx.net> <4B15ACA7.6070807@samsung.com>
 <200912020112.59668.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/2/2009 9:12 AM, Tobias Lorenz wrote:
> Hi,
> 
> ok, understood this problem.
> So, why not set this in si470x_fops_open directly after the si470x_start?
> It seems more appropriate to enable the RDS interrupt after starting the radio.
> 

OK, it makes sense. I will move it in si470x_fops_open.

> Bye the way, you pointed me to a bug. Instead of always setting de-emphasis in si470x_start:
> radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
> This should only be done, if requested by module parameter:
> radio->registers[SYSCONFIG1] = (de << 11) & SYSCONFIG1_DE; /* DE */
> 

Ah, That's right.

Thanks.
