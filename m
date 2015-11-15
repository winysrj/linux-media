Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34856 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbbKOUtd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 15:49:33 -0500
Received: by oige206 with SMTP id e206so74340813oig.2
        for <linux-media@vger.kernel.org>; Sun, 15 Nov 2015 12:49:32 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Nov 2015 20:49:32 +0000
Message-ID: <CAK2bqVL1kyz=gjqKjs_W6oge-_h8qjE=7OwPhaX=OH47U2+z+g@mail.gmail.com>
Subject: Trying to enable RC6 IR for PCTV T2 290e
From: Chris Rankin <rankincj@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

My Hauppauge RC5 remote control finally broke, and the PCTV T2 290e's
native RC5 remote control isn't suitable for VDR, and so I bought a
cheap RC6 remote as a replacement. The unit I chose was the Ortek
VRC-1100 Vista MCE Remote Control, USB ID 05a4:9881. I've been able to
switch the PCTV device into RC6 mode using "ir-keytable -p rc-6",
which does seem to execute the correct case of
em2874_ir_change_protocol(). However, when I press any buttons on my
new remote, I still don't see em2874_polling_getkey() being called,
which makes me wonder if the RC6 support is truly enabled.

Has anyone managed to use this device's RC6 functionality, please? I
can test patches for this driver (againt Linux 4.2.6).

FWIW, I did manage to configure VDR to use the MCE remote's native USB
dongle, although I needed to tweak my X server's configuration first:

Section "InputClass"
    Identifier "VDR IR dongle"
    MatchUSBID "05a4:9881"
    Option    "Ignore" "on"
EndSection

and even then, VDR *still* didn't recognise all of the keys.

Cheers,
Chris
