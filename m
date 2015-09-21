Return-path: <linux-media-owner@vger.kernel.org>
Received: from hl140.dinaserver.com ([82.98.160.94]:47565 "EHLO
	hl140.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbbIUQuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 12:50:16 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: =?UTF-8?Q?Germ=c3=a1n_Villar?= <german@by.com.es>,
	=?UTF-8?Q?Antonio_P=c3=a9rez_Barrero?= <antonioperez@by.com.es>
From: Javier Martin <javiermartin@by.com.es>
Subject: RFC: ov5640 kernel driver.
Message-ID: <5600334B.4090507@by.com.es>
Date: Mon, 21 Sep 2015 18:41:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
we want to a v4l2 driver for the ov5640 sensor from Omnivision.

AFAIK, there was an attempt in the past to mainline that driver [1] but 
it didn't make it in the end.

Some people were asking for the code for the ov5640 and the ov5642 to be 
merged [2] as well but IMHO both sensors are not that similar so that 
it's worth a common driver.

The approach we had in mind so far was creating a new, independent, 
v4l2-subdev driver for the ov5640 with mbus support.

I've found several sources out there with code for the ov5640 but, 
surprisingly, few attempts to mainline it. I would whether it is just 
people didn't take the effort or there was something wrong with the code.

Has anyone got some comments/advices on this before we start coding? Is 
anyone already working on this and maybe we can collaborate instead of 
having two forks of the same driver?

Regards,
Javier.

[1] https://lwn.net/Articles/470643/
[2] http://www.spinics.net/lists/linux-omap/msg69611.html
