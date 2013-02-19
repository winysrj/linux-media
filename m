Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46268 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab3BSBsR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Feb 2013 20:48:17 -0500
Received: by mail-ee0-f51.google.com with SMTP id d17so3054588eek.38
        for <linux-media@vger.kernel.org>; Mon, 18 Feb 2013 17:48:15 -0800 (PST)
Message-ID: <5122D999.3070405@gmail.com>
Date: Tue, 19 Feb 2013 02:47:05 +0100
From: =?UTF-8?B?R2HDq3RhbiBDYXJsaWVy?= <gcembed@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
CC: Fabio Estevam <festevam@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: coda: support of decoding
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I see in code source of coda driver that decoding is not supported.

ctx->inst_type = CODA_INST_DECODER;
v4l2_err(v4l2_dev, "decoding not supported.\n");
return -EINVAL;

Is there any technical reason or the code has not been written ?

Thanks a lot,
Best regards,
Gaëtan Carlier.
