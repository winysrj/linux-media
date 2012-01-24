Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57698 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2AXTHb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 14:07:31 -0500
Received: from dyn3-82-128-184-189.psoas.suomi.net ([82.128.184.189] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1RpliK-0004tO-UN
	for linux-media@vger.kernel.org; Tue, 24 Jan 2012 21:07:29 +0200
Message-ID: <4F1F0170.2070304@iki.fi>
Date: Tue, 24 Jan 2012 21:07:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: git bisect & Merge branch
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

How I can continue with bisect when I end up commit that is merge?

I was trying to find out reason for bug where core registers demux and 
dvr even there is no frontend.
crw-rw----+ 1 root video 212, 0 Jan 24 17:11 /dev/dvb/adapter0/demux0
crw-rw----+ 1 root video 212, 1 Jan 24 17:11 /dev/dvb/adapter0/dvr0


[crope@localhost linux]$ git bisect bad
d033e078566faed8c8f59baf97ee57ce2524ef5c is the first bad commit
[crope@localhost linux]$ git show d033e078566faed8c8f59baf97ee57ce2524ef5c
commit d033e078566faed8c8f59baf97ee57ce2524ef5c
Merge: 081a9d0 382414b
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Sat Oct 22 00:21:52 2011 +0200

     Merge branch 'pm-domains' into pm-for-linus

     * pm-domains:
       ARM: mach-shmobile: sh7372 A4R support (v4)
       ARM: mach-shmobile: sh7372 A3SP support (v4)
       PM / Sleep: Mark devices involved in wakeup signaling during suspend

[crope@localhost linux]$ git bisect log
git bisect start
# good: [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
git bisect good c3b92c8787367a8bb53d57d9789b558f1295cc96
# bad: [2a7ed6892256dcd7d445e29d9c497d85b8bc281f] DVBv5 test report
git bisect bad 2a7ed6892256dcd7d445e29d9c497d85b8bc281f
# bad: [81397a625d063403d80a25bba00fa1cb6d7e04f5] ARM: mark empty gpio.h 
files empty
git bisect bad 81397a625d063403d80a25bba00fa1cb6d7e04f5
# bad: [efb8d21b2c6db3497655cc6a033ae8a9883e4063] Merge branch 
'tty-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect bad efb8d21b2c6db3497655cc6a033ae8a9883e4063
# good: [094daf7db7c47861009899ce23f9177d761e20b0] Merge branch 'master' 
of git://git.infradead.org/users/linville/wireless-next into for-davem
git bisect good 094daf7db7c47861009899ce23f9177d761e20b0
# good: [1be025d3cb40cd295123af2c394f7229ef9b30ca] Merge branch 
'usb-next' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect good 1be025d3cb40cd295123af2c394f7229ef9b30ca
# good: [4e7e2a2008f5d8c49791c412849d5b0232d39bb3] Merge branch 
'for-linus' of git://opensource.wolfsonmicro.com/regmap
git bisect good 4e7e2a2008f5d8c49791c412849d5b0232d39bb3
# bad: [1442d1678ca7e53574fd403ba7bee6f4125d920c] Merge branch 'for-3.2' 
of git://linux-nfs.org/~bfields/linux
git bisect bad 1442d1678ca7e53574fd403ba7bee6f4125d920c
# good: [d29b20cd589128a599e5045d4effc2d7dbc388f5] nfsd4: clean up open 
owners on OPEN failure
git bisect good d29b20cd589128a599e5045d4effc2d7dbc388f5
# good: [9bd717c0dc8224cadfd66df7eeff98c987711d98] Merge branch 
'pm-runtime' into pm-for-linus
git bisect good 9bd717c0dc8224cadfd66df7eeff98c987711d98
# bad: [0ab1e79b825a5cd8aeb3b34d89c9a89dea900056] PM / Clocks: Remove 
redundant NULL checks before kfree()
git bisect bad 0ab1e79b825a5cd8aeb3b34d89c9a89dea900056
# good: [731b25a4ad3c27b44f3447382da18b59167eb7a1] PM / ACPI: Blacklist 
Vaio VGN-FW520F machine known to require acpi_sleep=nonvs
git bisect good 731b25a4ad3c27b44f3447382da18b59167eb7a1
# good: [081a9d043c983f161b78fdc4671324d1342b86bc] PM / Hibernate: 
Improve performance of LZO/plain hibernation, checksum image
git bisect good 081a9d043c983f161b78fdc4671324d1342b86bc
# good: [382414b93ac1e8ee7693be710e60c83eacc97c6f] ARM: mach-shmobile: 
sh7372 A4R support (v4)
git bisect good 382414b93ac1e8ee7693be710e60c83eacc97c6f
# bad: [d11c78e97e1d46a93eb468794da82a090143a72e] ACPI / PM: Add Sony 
VGN-FW21E to nonvs blacklist.
git bisect bad d11c78e97e1d46a93eb468794da82a090143a72e
# bad: [d033e078566faed8c8f59baf97ee57ce2524ef5c] Merge branch 
'pm-domains' into pm-for-linus
git bisect bad d033e078566faed8c8f59baf97ee57ce2524ef5c
# bad: [d033e078566faed8c8f59baf97ee57ce2524ef5c] Merge branch 
'pm-domains' into pm-for-linus
git bisect bad d033e078566faed8c8f59baf97ee57ce2524ef5c

-- 
http://palosaari.fi/
