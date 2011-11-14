Return-path: <linux-media-owner@vger.kernel.org>
Received: from csmtp2.one.com ([91.198.169.22]:51810 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab1KNLcQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 06:32:16 -0500
Received: from Jantjes-MacBook.local (ip51ce01a5.speed.planet.nl [81.206.1.165])
	by csmtp2.one.com (Postfix) with ESMTPA id A311A3044223
	for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 11:32:14 +0000 (UTC)
Message-ID: <4EC0FC3E.1050907@x34.nl>
Date: Mon, 14 Nov 2011 12:32:14 +0100
From: Jan <jan@x34.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: tt-1500b tuning problems
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi List,

I have a strange problem tuning my tt-s1500b card, the problem looks the one described in these 
posts (http://www.mail-archive.com/linux-media@vger.kernel.org/msg34251.html).

The frequencies I use are:

astra 19.2 12343000hz SR 27500 FEC 3/4 which works like a charm
and
astra 19.2 12515000hz SR 22000 FEC 5/6 which does not seem to tune

Currently I am testing with a 3.1.0-rc4 kernel and the media build drivers.

Is there something I can test or try to get the 2nd frequency with the SR of 22000 working?

Both frequencies have worked on my older install with a 2.6.39 kernel after I manually added some 
patches especially for this card. (Did not find my way to the media build system then).

Thanks.

Jan
