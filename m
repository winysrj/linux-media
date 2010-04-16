Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.sscnet.ucla.edu ([128.97.229.231]:56148 "EHLO
	smtp1.sscnet.ucla.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab0DPXUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 19:20:07 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o3GNK6tF002989
	for <linux-media@vger.kernel.org>; Fri, 16 Apr 2010 16:20:06 -0700
Received: from smtp1.sscnet.ucla.edu ([127.0.0.1])
	by localhost (smtp1.sscnet.ucla.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VcF+7d8Isp1O for <linux-media@vger.kernel.org>;
	Fri, 16 Apr 2010 16:19:54 -0700 (PDT)
Received: from smtp5.sscnet.ucla.edu (smtp5.sscnet.ucla.edu [128.97.229.235])
	by smtp1.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o3GNJlHB002523
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Apr 2010 16:19:47 -0700
Received: from weber.sscnet.ucla.edu (weber.sscnet.ucla.edu [128.97.42.3])
	by smtp5.sscnet.ucla.edu (8.13.8/8.13.8) with ESMTP id o3GNJctI005855
	for <linux-media@vger.kernel.org>; Fri, 16 Apr 2010 16:19:38 -0700
Received: from [128.97.221.45] ([128.97.221.45])
	by weber.sscnet.ucla.edu (8.14.2/8.14.2) with ESMTP id o3GNJdUH009190
	for <linux-media@vger.kernel.org>; Fri, 16 Apr 2010 16:19:39 -0700 (PDT)
Message-ID: <4BC8F087.3050805@cogweb.net>
Date: Fri, 16 Apr 2010 16:19:35 -0700
From: David Liontooth <lionteeth@cogweb.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: zvbi-atsc-cc device node conflict
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using a HVR-1850 in digital mode and get good picture and sound using

  mplayer -autosync 30 -cache 2048 dvb://KCAL-DT

Closed captioning works flawlessly with this command:

 zvbi-atsc-cc -C test-cc.txt KCAL-DT

However, if I try to run both at the same time, I get a device node 
conflict:

  zvbi-atsc-cc: Cannot open '/dev/dvb/adapter0/frontend0': Device or 
resource busy.

How do I get video and closed captioning at the same time?

Cheers,
Dave

