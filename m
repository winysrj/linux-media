Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758970Ab0J1OS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Oct 2010 10:18:58 -0400
Received: by iwn10 with SMTP id 10so2415966iwn.19
        for <linux-media@vger.kernel.org>; Thu, 28 Oct 2010 07:18:57 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Oct 2010 08:18:57 -0600
Message-ID: <AANLkTinHT_XPZJU9Xq2cScJoUUCfTps4PXFU9S2_fX=Q@mail.gmail.com>
Subject: Kworld usb 2800D audio
From: Tim Stowell <stowellt@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I'm able to capture video just fine with my  Kworld usb 2800D usb
device and the recent (I've installed the April v4l-dvb em28xx
driver), but I can't get any audio. I tried modprobe em28xx-alsa, and
the module loads, but alsa can't find any sound cards. Do I need the
snd-usb-audio driver? the usb device is based on the em2860 chip. Any
help would be greatly appreciated, thanks.

-Tim
