Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:42552 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab2BIVMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2012 16:12:33 -0500
Received: by vbjk17 with SMTP id k17so1369169vbj.19
        for <linux-media@vger.kernel.org>; Thu, 09 Feb 2012 13:12:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ_iqtY2y5+jo2rirm1LbfDHVytcnaXE5x+KuA_MD-H5N4pnwA@mail.gmail.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
	<CAJ_iqtbzWGjLFUbMu4useGeb2739ikRYSnQCm5E4Lej1SJ-vpQ@mail.gmail.com>
	<CAJ_iqtY2y5+jo2rirm1LbfDHVytcnaXE5x+KuA_MD-H5N4pnwA@mail.gmail.com>
Date: Thu, 9 Feb 2012 22:12:31 +0100
Message-ID: <CAJ_iqtauqw0KPO19q4cc527tKv-0PW-SLoQGfb_dob4Nwv8g6A@mail.gmail.com>
Subject: Re: [PATCH 00/35] Add a driver for Terratec H7
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Update:

On Thu, Feb 9, 2012 at 12:04 AM, Torfinn Ingolfsen <tingox@gmail.com> wrote:
> Never mind. after adding this patch:
> http://patchwork.linuxtv.org/patch/9691/
>
> and rebuilding the media drivers, the device is now detected:
> tingo@kg-f4:~$ dmesg | grep -i terratec
> [   19.755806] dvb-usb: found a 'TerraTec DTV StarBox DVB-T/C USB2.0
> (az6007)' in warm state.
> [   20.949045] DVB: registering new adapter (TerraTec DTV StarBox
> DVB-T/C USB2.0 (az6007))
> [   23.732039] Registered IR keymap rc-nec-terratec-cinergy-xs
> [   23.732442] dvb-usb: TerraTec DTV StarBox DVB-T/C USB2.0 (az6007)
> successfully initialized and connected.

I have now tested the TerraTec H7, both with w_scan and with Kaffeine.
Neither of then is able to find any channels from the H7. (The device
is connected to an external power supply). However, if I connect
another device (a PCTV nanoStick T2 290e) to the same cable, both
w_scan and Kaffeine find all the channels for my provider, and I can
watch the clear (unencrypted) ones in Kaffeine.

How can I debug the H7 further?
-- 
Regards,
Torfinn Ingolfsen
