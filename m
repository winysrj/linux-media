Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50638 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0IPCyB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 22:54:01 -0400
Received: by eyb6 with SMTP id 6so431723eyb.19
        for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 19:54:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Sep 2010 22:54:00 -0400
Message-ID: <AANLkTimt5bs1fNp=+36VLaTy0Kwi1rDPcpUTeN4z+c35@mail.gmail.com>
Subject: HVR 1600 Distortion
From: Josh Borke <joshborke@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've recently noticed some distortion coming from my hvr1600 when
viewing analog channels.  It happens to all analog channels with some
slightly better than others.  I am running Fedora 12 linux with kernel
version 2.6.32.21-166.

Output of lspci -v:

02:0a.0 Multimedia video controller: Conexant Systems, Inc. CX23418
Single-Chip MPEG-2 Encoder with Integrated Analog Video/Broadcast
Audio Decoder
        Subsystem: Hauppauge computer works Inc. WinTV HVR-1600
        Flags: bus master, medium devsel, latency 64, IRQ 10
        Memory at c0000000 (32-bit, non-prefetchable) [size=64M]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
        Kernel driver in use: cx18
        Kernel modules: cx18

I know I need to include more information but I'm not sure what to
include.  Any help would be appreciated.

Thanks,
-josh
