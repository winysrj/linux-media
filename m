Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33365 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423122AbcBQSBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 13:01:52 -0500
Received: by mail-io0-f177.google.com with SMTP id z135so46040593iof.0
        for <linux-media@vger.kernel.org>; Wed, 17 Feb 2016 10:01:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1455719247.3336.23.camel@pengutronix.de>
References: <1455715270-23757-1-git-send-email-p.zabel@pengutronix.de>
	<20160217113515.19c0f87a@recife.lan>
	<1455719247.3336.23.camel@pengutronix.de>
Date: Wed, 17 Feb 2016 16:01:51 -0200
Message-ID: <CAOMZO5COpeaX_-YHL=sVDPDMG6twp2ZbEMUyvqab+hRewpmdUA@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: add support for native order firmware files
 with Freescale header
From: Fabio Estevam <festevam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Philipp Zabel <philipp.zabel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 17, 2016 at 12:27 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Mauro,
>
> Am Mittwoch, den 17.02.2016, 11:35 -0200 schrieb Mauro Carvalho Chehab:
>> Em Wed, 17 Feb 2016 14:21:10 +0100
>> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
>>
>> > Freescale distribute their VPU firmware files with a 16 byte header
>> > in BIT processor native order. This patch allows to detect the header
>> > and to reorder the firmware on the fly.
>> > With this patch it should be possible to use the distributed
>> > vpu_fw_imx{53,6q,6d}.bin files directly after renaming them to
>> > v4l-coda*-imx{53,6q,6dl}.bin.
>>
>> IMHO, the best would be to add another patch to support the files with
>> their original names, falling back to v4l-coda*. We do this on other
>> drivers where more than one firmware file could be used.
>
> thank you for the suggestion. I'll follow up with another patch that
> also supports the firmware file names as they are distributed.

That would be nice. Thanks, Philipp
