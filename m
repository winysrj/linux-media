Return-path: <linux-media-owner@vger.kernel.org>
Received: from or-71-0-52-80.sta.embarqhsd.net ([71.0.52.80]:53990 "EHLO
	asgard.dharty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbbA2Evq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 23:51:46 -0500
Received: from [192.168.0.4] (buri.dharty.com [192.168.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: catchall@dharty.com)
	by asgard.dharty.com (Postfix) with ESMTPSA id 41FDD235D1
	for <linux-media@vger.kernel.org>; Wed, 28 Jan 2015 20:43:45 -0800 (PST)
Message-ID: <54C9BA7E.90907@dharty.com>
Date: Wed, 28 Jan 2015 20:43:42 -0800
From: catchall <catchall@dharty.com>
Reply-To: v4l@dharty.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Haupage 2250 / saa7164 kernel errors
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

About once a day, my tuner stops working and my logs fill up with the 
following messages:

2015-01-28T20:40:23.736478-08:00 mediapc kernel: [169020.845484] 
saa7164_cmd_send() No free sequences
2015-01-28T20:40:23.736480-08:00 mediapc kernel: [169020.845486] 
saa7164_api_i2c_read() error, ret(1) = 0xc
2015-01-28T20:40:23.736483-08:00 mediapc kernel: [169020.845489] 
s5h1411_readreg: readreg error (ret == -5)

I've seen a couple other posts about it in this mailing list with no 
responses yet.  Does anybody have an idea of why this could be 
happening, or any suggestions on what I could try to debug this issue?

Thanks,

David

