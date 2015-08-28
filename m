Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.aon.at ([195.3.96.77]:8982 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752786AbbH1WBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 18:01:08 -0400
Message-ID: <55E0DA18.7000405@a1.net>
Date: Sat, 29 Aug 2015 00:00:56 +0200
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hverkuil@xs4all.nl
Subject: Re: [BUG] STV0299 has bogus CAN_INVERSION_AUTO flag
References: <55DB3608.5010906@a1.net>
In-Reply-To: <55DB3608.5010906@a1.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pls fix this!!!

Either by fixing.
<https://github.com/torvalds/linux/blob/master/drivers/media/dvb-frontends/stv0299.c> around line 583.

or
<https://github.com/torvalds/linux/blob/master/drivers/media/dvb-core/dvb_frontend.c> line 2319

but there it's problematic coz they tried to be `smart' with this in the tuning functions...

And don't start nagging around that I'm supposed to use the `unlimited' capabilities API, coz IT IS NOT IMPLEMENTED
AND I AM NOT GONNA WRITE IT. 

<https://github.com/torvalds/linux/search?utf8=%E2%9C%93&q=DTV_FE_CAPABILITY>


peace


