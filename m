Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53982 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab2E1NG0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 09:06:26 -0400
Received: from dyn3-82-128-188-130.psoas.suomi.net ([82.128.188.130] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SYzeS-0000TE-9m
	for linux-media@vger.kernel.org; Mon, 28 May 2012 16:06:24 +0300
Message-ID: <4FC3784F.7000503@iki.fi>
Date: Mon, 28 May 2012 16:06:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: DVB USB: DVB demux configuration in case of SFE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I realized DVB demux is configured as a property of frontend. This was 
OK for the situation we implemented different standards as a different 
frontends (MFE). But as now, we have only single frontend which delivery 
system is changed. Different delivery systems will likely have different 
needs for demux configuration. Currently there is 3 different payloads 
used, 1) TS 188, 2)TS 204, 3) TS raw.

How we should resolve that issue?

TS type is needed to get from the demodulator and then configure demux 
according to that info.

regards
Antti
-- 
http://palosaari.fi/
