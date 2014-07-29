Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:56270 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaG2RG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jul 2014 13:06:26 -0400
Received: by mail-vc0-f175.google.com with SMTP id ik5so5115062vcb.6
        for <linux-media@vger.kernel.org>; Tue, 29 Jul 2014 10:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140729153050.GE6827@dragon>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
	<1405071403-1859-7-git-send-email-p.zabel@pengutronix.de>
	<20140721160128.27eb7428.m.chehab@samsung.com>
	<20140721191944.GK13730@pengutronix.de>
	<1406033433.4496.16.camel@paszta.hi.pengutronix.de>
	<20140729153050.GE6827@dragon>
Date: Tue, 29 Jul 2014 19:06:25 +0200
Message-ID: <CA+gwMccgFGxpDZFqZR=pEgnnc1z5rit4T+LsVKvp1KrWw7_aJA@mail.gmail.com>
Subject: Re: [PATCH v3 06/32] [media] coda: Add encoder/decoder support for CODA960
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Robert Schwebel <r.schwebel@pengutronix.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shawn,

On Tue, Jul 29, 2014 at 5:30 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> Hi Philipp,
>
> On Tue, Jul 22, 2014 at 02:50:33PM +0200, Philipp Zabel wrote:
>> The firmware-imx packages referenced in the Freescale meta-fsl-arm
>> repository on github.com contain VPU firmware files. Their use is
>> restricted by an EULA. For example:
>> http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.0.35-4.0.0.bin
>>
>> This contains the files vpu_fw_imx6q.bin and vpu_fw_imx6d.bin, which can
>> be converted into v4l-coda960-imx6q.bin and v4l-coda960-imx6dl.bin,
>> respectively, by dropping the headers and reordering the rest.
>> I described this for i.MX53 earlier here:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-July/181101.html
>
> I followed the step to generate the firmware v4l-coda960-imx6q, and
> tested it on next-20140725 with patch 'ARM: dts: imx6qdl: Enable CODA960
> VPU' applied on top of it.  But I got the error of 'Wrong firmwarel' as
> below.
>
> [    2.582837] coda 2040000.vpu: requesting firmware 'v4l-coda960-imx6q.bin' for CODA960
> [    2.593344] coda 2040000.vpu: Firmware code revision: 0
> [    2.598649] coda 2040000.vpu: Wrong firmware. Hw: CODA960, Fw: (0x0000), Version: 0.0.0

I just tried with the same kernel, and the above download, converted
with the program in the referenced mail, and I get this:

    coda 2040000.vpu: Firmware code revision: 36350
    coda 2040000.vpu: Initialized CODA960.
    coda 2040000.vpu: Unsupported firmware version: 2.1.9
    coda 2040000.vpu: codec registered as /dev/video0

    md5sum of /lib/firmware/v4l-coda960-imx6q.bin:
    af4971a37c7a3a50c99f7dfd36104c63

Note that I so far tested the kernel driver with the older firmware
version 2.1.5:

    coda 2040000.vpu: Firmware code revision: 32515
    coda 2040000.vpu: Initialized CODA960.
    coda 2040000.vpu: Firmware version: 2.1.5

    md5sum of /lib/firmware/v4l-coda960-imx6q.bin:
    f58119103d94adcd5c2d5070d65ebd26

I was under the impression that I had obtained this version from the
very same URI previously, but I am not 100% sure about that.
Also there is yet another version available from
http://www.freescale.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-3.10.17-1.0.0.bin,
which currently contains firmware version 3.1.1:

    coda 2040000.vpu: Firmware code revision: 46056
    coda 2040000.vpu: Initialized CODA960.
    coda 2040000.vpu: Unsupported firmware version: 3.1.1

    md5sum of /lib/firmware/v4l-coda960-imx6q.bin:
    2a087c2e4043c3c3a4104765a33b12aa

regards
Philipp
