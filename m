Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42412 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510Ab2GQM12 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jul 2012 08:27:28 -0400
Message-ID: <50055A23.5040008@iki.fi>
Date: Tue, 17 Jul 2012 15:27:15 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Jean-Fran=E7ois_Moine?= <moinejf@free.fr>,
	linux-media <linux-media@vger.kernel.org>
Subject: media_build: ov534_9.c:1381:3: error: implicit declaration of function
 'err'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jean-François,

I just tried to build drivers using media_build.git.
Could you look that issue?

/media_build/v4l/ov534_9.c: In function 'sd_init':
/media_build/v4l/ov534_9.c:1381:3: error: implicit declaration of 
function 'err' [-Werror=implicit-function-declaration]

Diff against 3.5-rc5 says:

26a27
 > #undef pr_fmt
1380c1381
< 		pr_err("Unknown sensor %04x", sensor_id);
---
 > 		err("Unknown sensor %04x", sensor_id);


regards
Antti

-- 
http://palosaari.fi/

