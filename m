Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.pb.cz ([109.72.0.115]:44129 "EHLO smtp5.pb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbaBXIkN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 03:40:13 -0500
Received: from [192.168.1.15] (unknown [109.72.4.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by smtp5.pb.cz (Postfix) with ESMTPS id 62B2580C67
	for <linux-media@vger.kernel.org>; Mon, 24 Feb 2014 09:40:10 +0100 (CET)
Message-ID: <530B056A.7050501@mizera.cz>
Date: Mon, 24 Feb 2014 09:40:10 +0100
From: kapetr@mizera.cz
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: af9035 vs. it913x
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

old it913x had support reporting of signal strength on IT9135 v2.
af9035 driver does not. Could that be corrected ?


And I would like to know:
How to get and build drivers from source with patches which are 
presented in this forum.

E.g. - driver it913x is now obsolete and IT9135 is now moved to driver 
af9035. OK.
But when I download:

git clone --depth=1 git://linuxtv.org/media_build.git

as described here:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

There are these changes/patches not included.
Is somewhere more actual  media_build.git to clone an build ?


Thanks

--kapetr
