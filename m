Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34449 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcCHGcV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 01:32:21 -0500
Received: by mail-qk0-f175.google.com with SMTP id x1so2290228qkc.1
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2016 22:32:21 -0800 (PST)
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com. [209.85.220.176])
        by smtp.gmail.com with ESMTPSA id o97sm639432qge.23.2016.03.07.22.32.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Mar 2016 22:32:20 -0800 (PST)
Received: by mail-qk0-f176.google.com with SMTP id o6so2280765qkc.2
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2016 22:32:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BY2PR20MB016874EF65B0FEEFB2CCDA6FBDB20@BY2PR20MB0168.namprd20.prod.outlook.com>
References: <BY2PR20MB016874EF65B0FEEFB2CCDA6FBDB20@BY2PR20MB0168.namprd20.prod.outlook.com>
Date: Tue, 8 Mar 2016 08:32:19 +0200
Message-ID: <CAAZRmGxfR4+h3CwQoOB_sJpOwVsuM2awRewbjCB8mOpmF-COBQ@mail.gmail.com>
Subject: Re: How to see the content of my device's EEPROM?
From: Olli Salonen <olli.salonen@iki.fi>
To: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
	<alexandrexavier@live.ca>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Load the module with i2c_debug on:

From: em28xx-i2c.c:

693         if (i2c_debug) {
694                 /* Display eeprom content */
695                 print_hex_dump(KERN_INFO, "eeprom ", DUMP_PREFIX_OFFSET,
696                                16, 1, data, len, true);
697
698                 if (dev->eeprom_addrwidth_16bit)
699                         em28xx_info("eeprom %06x: ... (skipped)\n", 256);
700         }

modprobe em28xx i2c_debug=1 should do it.

Cheers,
-olli

On 8 March 2016 at 05:03, Alexandre-Xavier Labonté-Lamoureux
<alexandrexavier@live.ca> wrote:
> Hello everyone,
>
> On the kernel version 4.3.3, when I do dmesg to see the content of the
> EEPROM of the device that I just connected, I don't see it.
>
> I only see this: https://justpaste.it/qchd
>
> On older kernel versions like 3.10, I had what I wanted:
> https://justpaste.it/qchh
>
> i2c eeprom 00: 1a eb 67 95 1a eb 51 50 50 00 20 03 82 34 6a 04
> i2c eeprom 10: 6e 14 27 57 06 02 00 00 00 00 00 00 00 00 00 00
> i2c eeprom 20: 02 00 01 00 f0 10 01 00 b8 00 00 00 5b 00 00 00
> i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
> i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 c4 00 00
> i2c eeprom 50: 00 a2 00 87 81 00 00 00 00 00 00 00 00 00 00 00
> i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 04 03 30 00 14 03
> i2c eeprom 70: 49 00 4f 00 4e 00 20 00 41 00 75 00 64 00 69 00
> i2c eeprom 80: 6f 00 34 03 49 00 4f 00 4e 00 20 00 41 00 75 00
> i2c eeprom 90: 64 00 69 00 6f 00 20 00 55 00 53 00 42 00 20 00
> i2c eeprom a0: 32 00 38 00 36 00 31 00 20 00 44 00 65 00 76 00
> i2c eeprom b0: 69 00 63 00 65 00 00 00 00 00 00 00 00 00 00 00
> i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> Why do newer kernels print less information to dmesg? How do I do if I want
> to see the content of my EEPROM on kernel v4.3.3 ?
>
> Thanks in advance,
> Alexandre-Xavier
