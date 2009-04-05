Return-path: <linux-media-owner@vger.kernel.org>
Received: from [84.77.67.98] ([84.77.67.98]:3477 "EHLO ventoso.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751024AbZDEQxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 12:53:19 -0400
Date: Sun, 5 Apr 2009 18:53:01 +0200
From: Luca Olivetti <luca@ventoso.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Claudio Chimera <ckhmer1l@live.it>,
	Vortice Rosso <vorticerosso@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Driver for GL861+AF9003+MT2060]
Message-ID: <20090405185301.3ffa3fa7@noname>
In-Reply-To: <49D5362B.6050209@iki.fi>
References: <BLU0-SMTP24C120D13E754132593F63988B0@phx.gbl>
	<49D39741.3080806@iki.fi>
	<BLU0-SMTP79150B3EBA5ECC6F81213A98880@phx.gbl>
	<49D5362B.6050209@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El Fri, 03 Apr 2009 01:03:23 +0300
Antti Palosaari <crope@iki.fi> escribió:

> You don't need to implement all those in most cases.
> read_ber, read_signal_strength, read_snr, read_ucblocks and
> get_frontend are not obligatory *required* in any? case.

Besides, IIRC, not all signal information functions were implemented
in the af9005 (I didn't know all the details of the chipset and the
expected scale in the dvb driver).
They're nice to have but not indispensable.

Bye
-- 
Luca
