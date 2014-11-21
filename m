Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:43531 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691AbaKUQNM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:13:12 -0500
Received: by mail-wi0-f179.google.com with SMTP id ex7so9427545wid.0
        for <linux-media@vger.kernel.org>; Fri, 21 Nov 2014 08:13:11 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 21 Nov 2014 17:13:09 +0100
Message-ID: <CAE1c1rTnU3svGTKgv3-u0DS3Tb+KKZHmn0=4fp1CrUZZ8b8gGA@mail.gmail.com>
Subject: terratec HTC XS HD USB
From: Robert N <nrobert13@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to get my USB tuner stick working on an openwrt, but
getting some errors.

using w_scan to scan the available channels, gives:

113000: sr6900 (time: 00:11) (time: 00:12) signal ok:
        QAM_64   f = 113000 kHz S6900C999
start_filter:1410: ERROR: ioctl DMX_SET_FILTER failed: 97 Message too long
Info: NIT(actual) filter timeout

I know the 113Mhz is a valid MUX, because tuner works well under windows.

Any hints what could be the reason of the error messages?

Thanks.
