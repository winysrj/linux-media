Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754039AbcK1HoL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 02:44:11 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A0242ACEC
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2016 07:44:09 +0000 (UTC)
Date: Mon, 28 Nov 2016 08:44:09 +0100
Message-ID: <87oa1082wm.wl-sleep_walker@suse.com>
From: Tomas Cech <sleep_walker@suse.com>
To: linux-media@vger.kernel.org
Subject: dip7000p: division by zero 
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have this device:

Bus 004 Device 018: ID 2304:0229 Pinnacle Systems, Inc. PCTV Dual DVB-T 2001e

connected to ARM based Turris Omnia router running 4.4.13 kernel.

I meet this issue more than often:

2016-11-27T16:42:34+01:00 err kernel[]: [17010.721803] Division by zero in kernel.
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.725975] CPU: 0 PID: 12589 Comm: kdvb-ad-1-fe-0 Not tainted 4.4.13-05df79f63527051ea0071350f86faf76-9 #1
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.725980] Hardware name: Marvell Armada 380/385 (Device Tree)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.725983] Backtrace:
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.725995] [<c001c130>] (dump_backtrace) from [<c001c328>] (show_stack+0x18/0x1c)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.725998]  r6:00000000 r5:600e0113 r4:c0688208 r3:00000000
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726011] [<c001c310>] (show_stack) from [<c02d93c0>] (dump_stack+0x98/0xac)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726018] [<c02d9328>] (dump_stack) from [<c001c294>] (__div0+0x1c/0x20)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726020]  r6:00000000 r5:00000000 r4:e4f73000 r3:00000006
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726030] [<c001c278>] (__div0) from [<c000de3c>] (Ldiv0+0x8/0x10)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726064] [<bfa2f3cc>] (dib7000p_set_frontend [dib7000p]) from [<bf87618c>] (dvb_ca_en50221_thread+0x8e0/0x9e0 [dvb_core]
)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726067]  r10:c06a8808 r9:e05b2000 r8:e4f73244 r7:2b82ea80 r6:00000002 r5:e4f73000
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726076]  r4:e05b2000
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726094] [<bf876044>] (dvb_ca_en50221_thread [dvb_core]) from [<bf877018>] (dvb_frontend_sleep_until+0xc30/0xcb0 [dvb_co
re])
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726097]  r9:e05b2000 r8:e05b21b0 r7:00000000 r6:c51ddf1c r5:e4f73000 r4:e05b2000
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726118] [<bf876e24>] (dvb_frontend_sleep_until [dvb_core]) from [<bf877658>] (dvb_frontend_thread+0x398/0x528 [dvb_core
])
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726121]  r6:c51ddf1c r5:e4f73000 r4:00000000
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726135] [<bf8772c0>] (dvb_frontend_thread [dvb_core]) from [<c0042a18>] (kthread+0xfc/0x100)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726138]  r10:00000000 r9:00000000 r8:00000000 r7:bf8772c0 r6:e4f73000 r5:00000000
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726147]  r4:c5d01a00
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726154] [<c004291c>] (kthread) from [<c0009d98>] (ret_from_fork+0x14/0x3c)
2016-11-27T16:42:34+01:00 warning kernel[]: [17010.726157]  r7:00000000 r6:00000000 r5:c004291c r4:c5d01a00
2016-11-27T16:42:34+01:00 debug kernel[]: [17010.726164] DiB7000P: setting a frequency offset of 0kHz internal freq = 0 invert = 0

As I was checking the code, this can be in path

dib7000p_set_frontend()
dib7000p_agc_startup()
dib7000p_set_dds()
dib7000p_get_internal_freq()
dib7000p_read_word()

There is lot of I2C read errors resembling dprintk from the last
function which is probably related to root cause (which I haven't
found yet).

IMHO dib7000p_read_word() lacks error reporting to higher levels. In
case of read failure last content is returned.

Then dib7000p_get_internal_freq() does some calculations but it
returns 0 if the registers were "read" as 0. If dib7000p_read_word()
fails, this is the place to provide sane value.

dib7000p_set_dds() uses returned value for divison.

When I use this tuner with my x86_64 based notebook
running 4.8.6 kernel it works perfectly so that rules out HW issue.

So, do you agree with my findings? Any ideas why there is so many I2C
read errors?

Thanks in advance.

Best regards,

Tomas Cech
