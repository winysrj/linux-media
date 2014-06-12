Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50463 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332AbaFLAXN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 20:23:13 -0400
Message-ID: <5398F2ED.4080309@iki.fi>
Date: Thu, 12 Jun 2014 03:23:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?ISO-8859-1?Q?Frank_?= =?ISO-8859-1?Q?Sch=E4fer?=
	<fschaefer.oss@googlemail.com>, LMML <linux-media@vger.kernel.org>
Subject: em28xx submit of urb 0 failed (error=-27)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do you have any idea about that bug?
kernel: submit of urb 0 failed (error=-27)

https://bugzilla.kernel.org/show_bug.cgi?id=72891

I have seen it recently very often when I try start streaming DVB. When 
it happens, device is unusable. I have feeling that it could be coming 
from recent 28xx big changes where it was modularised. IIRC I reported 
that at the time and Mauro added error number printing to log entry. 
Anyhow, it is very annoying and occurs very often. And people have 
started pinging me as I have added very many DVB devices to em28xx.

regards
Antti


-- 
http://palosaari.fi/
