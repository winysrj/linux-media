Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:51956 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab2BWJVA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 04:21:00 -0500
Message-ID: <4F4604F8.2050201@schinagl.nl>
Date: Thu, 23 Feb 2012 10:20:56 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] Firmware for AF9035/AF9033 driver
References: <201202222322.02424.hfvogt@gmx.net>
In-Reply-To: <201202222322.02424.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I'm supprised the AF9035/AF9033 driver requires a firmware. The Asus 
U3100 Mini plus doesn't require a 'firmware' really. The firmware that 
is loaded, only contains an IR mapping table.

Oliver

On 22-02-12 23:22, Hans-Frieder Vogt wrote:
> Firmware for the AF9035/AF9033 driver.
>
> irmware format for af903x driver:
> copied from it9135-driver by Jason Dong (C) 2011 ITE Technologies, INC.
>
> 00000000: 8 chars "AF9035BX"    Identifier of firmware
> 00000008: 4 bytes LE length of firmware following this:
>                  32 + 4 + 4 + 4 + 4 + 4 + Firmware_CODELENGTH +
>                  Firmware_SEGMENTLENGTH * Firmware_PARTITIONLENGTH * 5 +
>                  5 + 2 + Firmware_scriptSets[0] * 5;
> 0000000C: 32 chars firmware release version
> 0000002C: 4 bytes BE link version
> 00000030: 4 bytes BE ofdm version
> 00000034: 4 bytes LE firmware code length (Firmware_CODELENGTH)
> 00000038: 1 bytes number of firmware segments (Firmware_SEGMENTLENGTH)
> 00000039: 3 bytes filler (0)
> 0000003C: 1 bytes number of firmware partitions (Firmware_PARTITIONLENGTH)
> 0000003D: 3 bytes filler (0)
> 00000040: Firmware_CODELENGTH bytes
> 0000abcd: description of firmware segments, for each segment in every
> partition:
>          1 byte segment type (0: download firmware, 1: copy firmware, else:
> direct write firmware)
>          4 bytes LE segment length
> 0000bcde: 1 byte Firmware_SEGMENTLENGTH check
> 0000bcdf: 1 byte Firmware_PARTITIONLENGTH check
> 0000bce0: 3 bytes filler (0)
> 0000bce3: 2 bytes LE number of firmware (demodulator) scripts
> 0000bce5: list of firmware scripts, for each entry:
>          4 bytes LE address
>          1 byte value
>
> Signed-off-by: Hans-Frieder Vogt<hfvogt@gmx.net>
>
> http://home.arcor.de/hfvogt/af903x/dvb-usb-af9035-03.fw =>  for Terratec T5
> Ver. 2 / T6
> http://home.arcor.de/hfvogt/af903x/dvb-usb-af9035-04.fw =>  for Avermedia A867
>
> Hans-Frieder Vogt                       e-mail: hfvogt<at>  gmx .dot. net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
