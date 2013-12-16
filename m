Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46838 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755201Ab3LPSLi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 13:11:38 -0500
Message-ID: <52AF4257.9030000@iki.fi>
Date: Mon, 16 Dec 2013 20:11:35 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: device@lanana.org
CC: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: video4linux device name request for Software Defined Radio
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We need new video4linux device name for Software Defined Radio devices. 
Device numbers are allocated dynamically. Desired device name was 
/dev/sdr, but as it seems to be already reserved, it was made decision 
to apply /dev/swradio instead.


81 char	video4linux
/dev/swradio0    Software Defined Radio device


Regards
Antti

-- 
http://palosaari.fi/
