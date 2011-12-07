Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab1LGNMf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 08:12:35 -0500
Message-ID: <4EDF6640.801@redhat.com>
Date: Wed, 07 Dec 2011 11:12:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: gennarone@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
References: <4EDE27A0.8060406@gmail.com>
In-Reply-To: <4EDE27A0.8060406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-12-2011 12:33, Gianluca Gennari wrote:
> Hi All,
>
> I have a Terratec Cinergy Hybrid T USB XS stick (USB 0ccd:0042).
> This device is made of the following components:
> - Empiatech em2880 USB bridge;
> - Zarlink zl10353 demodulator;
> - Xceive XC3028 tuner;
>
> For this device, the ZARLINK456 define is set to true so it is using the
> firmwares with type D2633 for the XC3028 tuner.
>
> I found out that:
> 1) the DTV7 firmware works fine in VHF band (bw=7MHz);
> 2) the DTV8 firmware works fine in UHF band (bw=8MHz);
> 3) the DTV78 firmware works fine in UHF band (bw=8MHz) but it doesn not
> work at all in VHF band (bw=7MHz);
>
> In fact, when the DTV78 firmware is loaded and I try to tune a VHF
> channel, the frequency lock is ciclically acquired for a second and
> immediately lost.
> So the proposed patch forces a reload of the DTV7 firmware every time a
> 7MHz channel is requested.
> The only drawback is that channel change from VHF to UHF or viceversa is
> slightly slower.
> Devices using the D2620 firmwares are unaffected.

Hi Gianluca,

The issues with firmware DTV78 x DTV7/DTV8 are old. No matter what we do,
we end by having troubles, as the issue is Country-dependent. For example,
Australia requires a different firmware than Germany, due to the differences
on the VHF/UHF bands.

I prefer if you could work into a patch that would add some modprobe parameter
to disable the current "autodetection" way, allowing to override the firmware
used for VHF and UHF.

Thanks,
Mauro
