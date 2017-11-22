Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout01.posteo.de ([185.67.36.141]:50948 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751476AbdKVNz4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Nov 2017 08:55:56 -0500
Received: from submission (posteo.de [89.146.220.130])
        by mout01.posteo.de (Postfix) with ESMTPS id 41CE920EAD
        for <linux-media@vger.kernel.org>; Wed, 22 Nov 2017 14:47:05 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Nov 2017 14:47:04 +0100
From: Martin Kepplinger <martink@posteo.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org
Subject: Re: media: coda: sources of =?UTF-8?Q?coda=5Fregs=2Eh=3F?=
In-Reply-To: <1511347200.17007.1.camel@pengutronix.de>
References: <15f29890-d029-95a3-c00d-73ed566ff172@posteo.de>
 <1511347200.17007.1.camel@pengutronix.de>
Message-ID: <5a4e281a3dba74900605bc9e92d0df2e@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 22.11.2017 11:40 schrieb Philipp Zabel:
> Hi Martin,
> 
> On Thu, 2017-11-09 at 23:14 +0100, Martin Kepplinger wrote:
>> Hi Philipp,
>> 
>> As I'm reading up on the coda driver a little, I can't seem to find 
>> the
>> vendor's sources for the coda_regs.h definitions. Could you point me 
>> to
>> them?
> 
> I don't know for sure what information Javier based the CodaDx6 
> register
> names on, but I assume that he used the old LGPLed i.MX VPU libraries
> that Freescale once distributed. At least that's what I looked at for
> the CODA960 additions: The BSP "L3.0.35_12.09.01.01_GA_source.tar.gz"
> contained a tarball "pkgs/imx-lib-12.09.01.tar.gz" with a header file
> "imx-lib-12.09.01/vpu/vpu_reg.h" inside. I believe the current BSP
> versions distributed by NXP do not include this library anymore.

Great! Thanks for the details.
