Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:44004 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756195Ab1LOLij (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 06:38:39 -0500
Received: from [195.7.61.12] (killala.koala.ie [195.7.61.12])
	(authenticated bits=0)
	by killala.koala.ie (8.14.4/8.13.7) with ESMTP id pBFBR0sn004728
	for <linux-media@vger.kernel.org>; Thu, 15 Dec 2011 11:27:01 GMT
Message-ID: <4EE9D984.2080604@koala.ie>
Date: Thu, 15 Dec 2011 11:27:00 +0000
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: problems with mythtv and pvr-350
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changing channel stopped working ages ago (5-6 months).
i assumed that it was a bug in myth. now i am wondering.

as far as i can see, mytht pauses the device when changing channel.
but somewhere along the way it chokes when unpausing (poll errors).

i notice that hans made some changes in this area back in september.
has anyone updated the myth code to support the new ioctls?


running myth master and media_build for the drivers.

any help gratefully received.
-- 
simon
