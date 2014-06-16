Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46134 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbaFPIu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jun 2014 04:50:28 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so3607977wib.0
        for <linux-media@vger.kernel.org>; Mon, 16 Jun 2014 01:50:27 -0700 (PDT)
Message-ID: <539EAF93.1020700@gmail.com>
Date: Mon, 16 Jun 2014 10:49:23 +0200
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <festevam@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [CODA] Info about internal buffers in CodaDX6
References: <538D8804.2010900@gmail.com>
In-Reply-To: <538D8804.2010900@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
No one can give me more information about these registers ?
Thank you.
Bets regards,
Gaëtan Carlier.

On 06/03/2014 10:32 AM, Gaëtan Carlier wrote:
> Dear,
> I am back to add support of h.264 decoding using Coda DX6 on i.MX27
> (after long months of inactivity).
> I base my work on driver from linux 2.6.22 (libvpu) and last coda.c from
> linux-next/master.
>
> When I send DEC_SEQ_INIT command, it fails but I don't know why.
> 1) Which internal buffers do Coda DX6 really have/used for decoding
> PARABUF, WORKBUF, PSBUF, ...) ?
> 2) What is their role ?
> 3) I see in some code that there is a command
> CODA_RET_DEC_SEQ_ERR_REASON (0x1E0), which has the same opcode has
> RET_DEC_SEQ_NEXT_FRAME_NUM, but when I run this command after
> DEC_SEQ_INIT, it returns 1 that does not seems to be correct error
> (regarding RetCode enum in vpu_lib.h in libvpu)
>
> Code is based on 3.6.0 kernel revision with some backport from more
> recent version of coda.c
>
> Thanks a lot for your help.
> Best regards,
> Gaëtan Carlier.

