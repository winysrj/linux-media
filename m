Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.pcl-iptrial02.plus.net ([212.159.7.105]:36543 "EHLO
	PCL-iptrial02.plus.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753638AbZHQSBx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Aug 2009 14:01:53 -0400
Received: from [80.229.217.79] (helo=[192.168.2.100])
	 by pih-relay08.plus.net with esmtpa (Exim) id 1Md6NA-0004sn-L1
	for linux-media@vger.kernel.org; Mon, 17 Aug 2009 18:51:57 +0100
Message-ID: <4A8998B9.3030700@chipsugar.plus.com>
Date: Mon, 17 Aug 2009 18:51:53 +0100
From: Darren Wilkinson <lintv@chipsugar.plus.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: error with dvb-bt8xx needing a rmmod -f and a modprobe again
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've got a bt8xx based dvb card and have had problems with the card in
multiple distros all with kernels >=2.6.28. The 2.6.27 or less also
worked on all distros that had them available.

My card is a Nebula Electronics Digitv pci card using the dvb-bt8xx and
nxt6000 modules. The problem I have is that when I boot up any linux
distro the card won't work in mythtv until I rmmod -r dvb-bt8xx &
modprobe dvb-bt8xx. The correct entries are created in /dev/dvb/ and the
card is detected correctly by dvb software but won't actually scan or
tune to anything.

I've searched the internet and looked at the mailing list archives and
only found the following reference to my problem:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/368215 (the digitv
card with the zarlink module is reported as having the same problem in
this page. Also the post by "chipsugar" is mine)
I don't have kaffeine or mandriva installed any more but can confirm
this is an issue with mythbuntu and gentoo with mythtv and dvbscan and
tzap. Building the modules into the kernel also fail obviously.

