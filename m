Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:51063 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab3I3FsQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 01:48:16 -0400
Message-ID: <52490EEB.1090806@gtsys.com.hk>
Date: Mon, 30 Sep 2013 13:40:59 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Subject: iram pool not available for MX27
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phillipp,

hope things doing OK.

I recently update to the 3.12-rc kernel and hit this problem below.

[ 3.377790] coda coda-imx27.0: iram pool not available
[ 3.383363] coda: probe of coda-imx27.0 failed with error -12

I read your comments of the patch-set using platform data rather then 
hard coded addresses to get
the ocram from a SoC.

I checked the imx27.dtsi for the iram (coda: coda@..) definition and 
compare with the former hard coded address and size it matches.

My .config also has the CONFIG_OF set.

Any Idea what's go wrong?

Chris

-- 
GTSYS -
Unit A01, 24/F Gold King Industrial Building,
35-41 Tai Lin Pai Road, Kwai Chung,
Hong Kong
新界葵涌大連排道35-41號金基工業大廈24樓A01室

