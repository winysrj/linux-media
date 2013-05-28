Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:60106 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933Ab3E1OJJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 10:09:09 -0400
In-reply-to: <519B88E8.3040101@cogentembedded.com>
References: <201305180101.11383.sergei.shtylyov@cogentembedded.com>
 <OFC9B7B505.2CDF0AA3-ON80257B71.00291B65-80257B71.002952EB@eu.necel.com>
 <519A1FFC.6000304@cogentembedded.com>
 <OF0ABE628B.1C271A20-ON80257B72.002ED824-80257B72.003627CD@LocalDomain>
 <OF7D5F7F7E.CF4ED120-ON80257B72.0042ED42-80257B72.004332EB@eu.necel.com>
 <519B88E8.3040101@cogentembedded.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, magnus.damm@gmail.com, matsu@igel.co.jp,
	mchehab@redhat.com, vladimir.barinov@cogentembedded.com
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH v5] V4L2: soc_camera: Renesas R-Car VIN driver
Message-id: <OF9A21FD79.EFF60097-ON80257B79.004D3CC5-80257B79.004DB2B3@eu.necel.com>
Date: Tue, 28 May 2013 15:08:33 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei, Vladimir,

> > Oops, the comments about the captured image contents are my fault.
> > However, the unhandled irq after stopping capture is still an issue.
> 
>     Thanks for letting us know.
The good news is that your driver works fine. 

The problem I saw only occurs when your patches were integrated into 
Simon's next branch (which was renesas-next-20130515v2+v3.10-rc1), so I 
guess something in the rc1 caused problems. Once I tested the driver 
against 3.9, it works fine.

Thanks
Phil
