Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60109 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANLnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2015 06:43:51 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so10236888wiv.1
        for <linux-media@vger.kernel.org>; Wed, 14 Jan 2015 03:43:49 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 14 Jan 2015 12:43:49 +0100
Message-ID: <CAPx3zdRrVspDeHyaS1U1O1MAbJngB7WxDVPgW8QqgbZDrmJgcA@mail.gmail.com>
Subject: HELP: tzap, signal 1f, FE_HAS_LOCK, no demux on Ubuntu 14.04 LTS,
 Device Siano ID 187f:0600, DVB-T
From: Francesco Other <francesco.other@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi to all,

I have this output from tzap

Version: 5.10   FE_CAN { DVB-T }
tuning to 698000000 Hz
video pid 0x0654, audio pid 0x0655
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 0000 | snr 0104 | ber 00000000 | unc 00000000 | FE_HAS_LOCK
...
...

and I can't receive the channel (no video, no audio, no service from multiplex).

Maybe a demux problem?

Ubuntu 14.04 LTS, Device Siano ID 187f:0600, DVB-T

Thanks for any help

Francesco
