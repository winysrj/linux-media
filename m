Return-path: <linux-media-owner@vger.kernel.org>
Received: from persephone.nexusuk.org ([217.172.134.9]:50097 "EHLO nexusuk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab2GDQEQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 12:04:16 -0400
Received: from [146.90.238.24] (helo=atlantis.nexusuk.org)
	by nexusuk.org with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.63)
	(envelope-from <steve@nexusuk.org>)
	id 1SmS3q-00088y-Sk
	for linux-media@vger.kernel.org; Wed, 04 Jul 2012 17:04:14 +0100
Message-ID: <4FF4697C.8080602@nexusuk.org>
Date: Wed, 04 Jul 2012 17:04:12 +0100
From: Steve Hill <steve@nexusuk.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: re: pctv452e
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 >> Ps. Steve, could you please give me full version of kernel which
 >> works with pctv452e?

I think it was 2.6.37-1-kirkwood from Debian which I was using (this is 
an ARM system).

 > As the new DVB-USB fixes many bugs I ask you to test it. I converted 
 > pctv452e driver for you:
 >
 > http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e
 >
 > Only PCTV device supported currently, not TechnoTrend at that time.

Can I ask why it only works on the PCTV devices?  I was under the 
impression that the TechnoTrend hardware was identical?


If you are able to provide any pointers as to where the TechnoTrend 
support is broken (or what debugging I should be turning on to figure 
out where it is broken) then that would be helpful.

Thanks.

-- 

  - Steve

