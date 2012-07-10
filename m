Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49439 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab2GJMRW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 08:17:22 -0400
Received: from dyn3-82-128-190-162.psoas.suomi.net ([82.128.190.162] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SoZNY-0000o4-VD
	for linux-media@vger.kernel.org; Tue, 10 Jul 2012 15:17:20 +0300
Message-ID: <4FFC1D4A.3040703@iki.fi>
Date: Tue, 10 Jul 2012 15:17:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Q: use of enum in struct dtv_frontend_properties
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am adding DTMB support (again) for DVB API. There is new parameter 
interleaving needed. Currently it has 3 values. I defined it as a enum 
as typedef enum is not allowed anymore in Kernel.

Should I define it as (enum fe_interleaving) or (u8) in struct 
dtv_frontend_properties?

enum fe_interleaving {
	INTERLEAVING_NONE,
	INTERLEAVING_240,
	INTERLEAVING_720,
};

struct dtv_frontend_properties {
	enum fe_interleaving    interleaving;
};

*** OR ***:

struct dtv_frontend_properties {
	u8    interleaving;
};



regards
Antti



-- 
http://palosaari.fi/

