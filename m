Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52470 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZJQTBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2009 15:01:48 -0400
Received: from [192.168.0.42] ([83.221.231.7])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.13.6/8.13.6/Debian-1) with ESMTP id n9HJ1prI029523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Sat, 17 Oct 2009 21:01:51 +0200
Message-ID: <4ADA149E.1070704@s5r6.in-berlin.de>
Date: Sat, 17 Oct 2009 21:01:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: 2.6.32 regression: can't tune DVB with firedtv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,

I just switched from kernel 2.6.31 to 2.6.32-rc5.  Using kaffeine, I
can't tune FireDTV-C and FireDTV-T boxes via the firedtv driver anymore.
Electronic program guide data is still displayed though.

Under 2.6.31, I used firedtv at the same patchlevel as present in
2.6.32-rc5, hence I guess that it is a DVB core problem rather than a
driver problem.

Any suggestions where to look for the cause?

(I am not subscribed to the list.)
-- 
Stefan Richter
-=====-==--= =-=- =---=
http://arcgraph.de/sr/
