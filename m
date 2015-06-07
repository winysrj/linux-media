Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34291 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbbFGWVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2015 18:21:06 -0400
Received: by iebmu5 with SMTP id mu5so51978191ieb.1
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2015 15:21:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 7 Jun 2015 15:21:06 -0700
Message-ID: <CAAT-iuuO1L=ft+Mw27T156JfY1j+-Xdr42TVSxjdGNA9yowYZA@mail.gmail.com>
Subject: Obtain Si2157 and LGDT3306A signal stats from HVR955Q?
From: Doug Lung <dlung0@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello! this is my first post here, although I've benefited from all
the work of the contributors over the year. Thanks!

I'm looking for help getting similar signal statistics from the new
Hauppauge HVR955Q (Si2157, LGDT3306A, CX23102) USB ATSC tuner that I'm
now getting from the Hauppauge Aero-M (MxL111SF, LGDT3305).  I'm
currently using DVBv3 API in my programs but am open to switching to
the DVBv5 API if necessary.

I applied Antti Palosaari's "si2157: implement signal strength stats"
patch to the media_build and dvb-fe-tool with dvbv5-zap now returns
relatively accurate RSSI data in dBm from the HVR955Q but no SNR or
packet error data. dvb-fe-tool provides a full set of data
(unformatted) from the Aero-M but only Lock and RSSI (formatted in
dBm) from the HVR955Q.

The SNR and packet error data is available from the HVR955Q in raw
form in DVBv3 applications like femon. The Si2157 RSSI in dBm is not.
The DVBv3 apps show the "signal quality" based on SNR margin above
threshold from the LGDT3306A.

Any suggestions on modifying the HVR955Q driver to provide RSSI
(unformatted is okay) from the Si2157 with the DVBv3 API? That's
preferred since it will work with my existing Aero-M signal testing
programs.

Alternatively, is there a way to obtain full DVBv5 API compliant
signal quality data (RSSI, SNR, uncorrected packets) from the
HVR955Q's LGDT3306A so I can modify my programs to use the linuxdvb.py
API v5.1 bindings?

      ...Doug Lung
