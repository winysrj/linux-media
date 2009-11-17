Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:42120 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZKQJ42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 04:56:28 -0500
Received: by pwi3 with SMTP id 3so3867395pwi.21
        for <linux-media@vger.kernel.org>; Tue, 17 Nov 2009 01:56:33 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Nov 2009 17:56:33 +0800
Message-ID: <51d384e10911170156x1e8f18afh48369a4cd664b45f@mail.gmail.com>
Subject: [PATCH] dvb-core: Fix ULE decapsulation bug when less than 4 bytes of
	ULE SNDU is packed into the remaining bytes of a MPEG2-TS frame
From: Ang Way Chuang <wcang79@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hilmar Linder <hlinder@cosy.sbg.ac.at>,
	Wolfram Stering <wstering@cosy.sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ULE (Unidirectional Lightweight Encapsulation RFC 4326) decapsulation
code has a bug that incorrectly treats ULE SNDU packed into the remaining
2 or 3 bytes of a MPEG2-TS frame as having invalid pointer field on the
subsequent MPEG2-TS frame.

This patch was generated against v2.6.32-rc7, however it wasn't tested
using that kernel. Similar patch was applied and tested using 2.6.27 which
is similar to the latest dvb_net.c, except for network device statistical data
structure. I suspect that this bug was introduced in kernel version 2.6.15,
but had not verified it.

Care has been taken not to introduce more bug by fixing this bug, but
please scrutinize the code for I always produces buggy code.

Signed-off-by: Ang Way Chuang <wcang@nav6.org>
