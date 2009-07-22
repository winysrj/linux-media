Return-path: <linux-media-owner@vger.kernel.org>
Received: from eyemagnet.com ([202.160.117.202]:46892 "EHLO eyemagnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZGVB2T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:28:19 -0400
Received: from [192.168.1.192] (unknown [64.81.73.170])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by eyemagnet.com (Postfix) with ESMTP id E7AAE8223
	for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 13:09:34 +1200 (NZST)
Message-ID: <4A6666CC.7020008@eyemagnet.com>
Date: Tue, 21 Jul 2009 18:09:32 -0700
From: Steve Castellotti <sc@eyemagnet.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: offering bounty for GPL'd dual em28xx support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone-

     Apologies in advance for spamming the list, but we're after adding 
dual device support for the existing, GPL'd em28xx tuner driver 
currently in the mainline Linux kernel. We do not have this development 
resource in house and had hoped perhaps someone on the list might be 
capable and interested (or able to point us in the appropriate direction).


     By way of more detail, it seems that multiple times in the past, 
other users have also requested this feature, but it is still not 
currently available in the current GPL'd driver. For some time support 
may have been present in the "em28xx-new" driver, provided by Markus 
Rechberger, but I have since been told it is "discontinued, and does not 
compile anymore with the latest kernels."


     This message thread as recently as April 9th, 2009, seems to 
indicate interest is still present at the community level, but no 
resolution was reached by the tail of the conversation:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg04245.html


     Going further back, it does seem that the em28xx-new driver at one 
point successfully addressed this issue, so supporting multiple devices 
should be possible with driver modification:

http://mcentral.de/pipermail/em28xx/2008-November/002111.html


     We can confirm that a development system running Fedora 11 with the 
latest stable kernel (2.6.29.5-191.fc11.i686.PAE), with identical em28xx 
devices connected still exhibits the error message "v4l2: ioctl queue 
buffer failed: No space left on device" when attempting to display video 
input on two identical em28xx devices simultaneously.

     On the other hand, display is successful through either device when 
trying to display individually (with both still connected).


     We are a small company, which relies on the Linux platform for the 
core of our products and services. Occasionally a situation presents 
itself for us to contribute back to the Open Source community (in 
however small a fashion), either by releasing existing code or 
contracting a small amount of work to be performed and subsequently 
released under the GPL. This is one such instance.


     If anyone is interested in contributing such work and is prepared 
to quote for what they feel their time would be worth, please do not 
hesitate to contact me.

     Again, apologies if this message appears to be a misuse of the 
mailing list, hopefully our intentions are understandable!


Cheers


-- 

Steve Castellotti
sc@eyemagnet.com
Technical Director
Eyemagnet Limited
http://www.eyemagnet.com
