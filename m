Return-path: <linux-media-owner@vger.kernel.org>
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:26369 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab1LHABQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 19:01:16 -0500
Received: from aamtaout02-winn.ispmail.ntl.com ([81.103.221.35])
          by mtaout03-winn.ispmail.ntl.com
          (InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP
          id <20111207222828.WTKW17949.mtaout03-winn.ispmail.ntl.com@aamtaout02-winn.ispmail.ntl.com>
          for <linux-media@vger.kernel.org>; Wed, 7 Dec 2011 22:28:28 +0000
Received: from localhost.localdomain ([82.25.208.140])
          by aamtaout02-winn.ispmail.ntl.com
          (InterMail vG.3.00.04.00 201-2196-133-20080908) with ESMTP
          id <20111207222828.PBRM5924.aamtaout02-winn.ispmail.ntl.com@localhost.localdomain>
          for <linux-media@vger.kernel.org>; Wed, 7 Dec 2011 22:28:28 +0000
Message-ID: <4EDFE889.3010501@tesco.net>
Date: Wed, 07 Dec 2011 22:28:25 +0000
From: John Pilkington <J.Pilk@tesco.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: media_build script and Scientific Linux 6 / CentOS 6 / RHEL 6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I used the media_build script to build modules for the Scientific Linux 
6 distro which is, I understand, one of the near-clones of RHEL 6, which 
are expected to have a working life of several years.  My kernel 
version, with security updates, is currently 2.6.32-131.21.1.el6.i686

The build needed utilities that I did not have installed; the script 
provided their names but apologised for its inability to identify the 
packages that would provide them because it did not recognise the 
distro.  This list is in response to its invitation to submit details.

Utility:	lsdiff
Package name:	patchutils
Repo:		SL6

Utility:	Digest::SHA
Package name:	perl-Digest-SHA
Repo:		SL6 security updates

Utility:	Proc::ProcessTable
Package name:	perl-Proc-ProcessTable
Repo:		SL6 epel

After installing these, and the kernel-devel package, the build 
completed and I have been able to bring into service a usb device that 
had resisted my earlier efforts on the nominally more up-to-date Fedora 
14.  dmesg identifies it as a 'KWorld UB499-2T T09(IT9137)' and some 
characteristics that I see are not mentioned on its wiki page.  I'll 
report on that separately, but there's a narrative account here:

http://www.mail-archive.com/atrpms-users@atrpms.net/msg09417.html

Thanks!

John Pilkington
