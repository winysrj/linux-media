Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.e-consultation.org ([185.53.129.30]:33109 "EHLO
        www.e-consultation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750988AbdG3NOM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 09:14:12 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by www.e-consultation.org (Postfix) with ESMTP id BD44220BE0A02
        for <linux-media@vger.kernel.org>; Sun, 30 Jul 2017 14:55:56 +0200 (CEST)
Received: from www.e-consultation.org ([127.0.0.1])
        by localhost (new-www.e-consultation.org [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CHPFXM6dHLjR for <linux-media@vger.kernel.org>;
        Sun, 30 Jul 2017 14:55:52 +0200 (CEST)
Received: from [192.168.0.3] (cpc69060-oxfd26-2-0-cust814.4-3.cable.virginm.net [82.6.51.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: d.r.newman@e-consultation.org)
        by www.e-consultation.org (Postfix) with ESMTPSA id 8558D20BE01E2
        for <linux-media@vger.kernel.org>; Sun, 30 Jul 2017 14:55:52 +0200 (CEST)
To: linux-media@vger.kernel.org
From: Dave Newman <d.r.newman@e-consultation.org>
Subject: Re: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
Message-ID: <bc863191-8f32-d702-f7f0-06a942d29d43@e-consultation.org>
Date: Sun, 30 Jul 2017 13:55:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I can confirm the problems with the cx23885 driver reported by Steven
Toth on 6 June 2017. He found that:

 > I tried the card in a different older Intel i7 board and it worked
 > flawlessly. I then started to wonder if it was some new
 > incompatibility introduced with Kaby Lake. I had tweaked the UEFI
 > settings on the new Kaby Lake board to enable VT-d/VT-x since I wanted
 > to run Linux as a host OS with Windows 10 running on top of qemu/KVM.
 > Upon resetting the UEFI settings to their defaults (VT-d/VT-x
 > disabled) the card worked without issue.

Like him:

- I have a recent Hauppauge WinTV-quadHD TV tuner PCIe card

- I have a new fast multi-processor CPU. He found that there were no
problems on

- Enabling debug output for the cx23885 driver *fixes* the issue
(options cx23885 debug=5), letting me run a scan of DVB channels.

Unlike him:

- my CPU is an 8 core Ryzen 1700 on a new Gigabyte AB350 motherboard.

- turning off iommu does not fix the problem.

I do not know the cx23885 code well enough to propose any patches, but I
am happy to do debugging and testing. One thing I noticed is that
i2cdetect output differs from that on
https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-quadHD_(DVB-T/T2/C).
E.g.

       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: 30 31 32 33 34 35 36 37 -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
60: -- -- -- -- UU -- UU -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --

Anything from 60 and above is listed as UU.

The motherboard is known to have problems with chained IRQs, so the 
latest Ubuntu kernels use independent IRQs to avoid an interrupt storm 
on IRQ 7.

Apart from that, let me know what else I should test.

-- 
David Newman
www.e-consultation.org
@davidrnewman
Tel. 01865 429750 or 077707 35474
