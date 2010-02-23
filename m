Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:5573 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab0BWKxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 05:53:09 -0500
Received: by ey-out-2122.google.com with SMTP id d26so834250eyd.19
        for <linux-media@vger.kernel.org>; Tue, 23 Feb 2010 02:53:07 -0800 (PST)
Message-ID: <4B83B577.3000404@gmail.com>
Date: Tue, 23 Feb 2010 12:01:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	e9hack@googlemail.com, linux-media@vger.kernel.org
Subject: tda10023.c: misplaced parentheses?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In tda10023_read_signal_strength() we have:

	u16 gain = ((255-tda10023_readreg(state, 0x17))) + (255-ifgain)/16;
-------------------------------------------------------^
The closing parenthesis appears misplaced, should this be:

	u16 gain = ((255-tda10023_readreg(state, 0x17)) + (255-ifgain))/ 16;
----------------------------------------------------------------------^
Or are the double parentheses just unnecessary?

Roel
