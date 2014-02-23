Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.vif.com ([216.239.64.153]:35118 "EHLO zanzibar.vif.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbaBYJKy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:10:54 -0500
Subject: patch for media-build for CentOS release 6.5 (Final)
From: Jacques Lussier <tech@cognotek.com>
Reply-To: tech@cognotek.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Feb 2014 14:35:48 -0500
Message-ID: <1393184148.4292.9.camel@cognotek.dyndns-ip.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

At the end is my output in Terminal while running ./build. The patch I
applied is :

Perl Extension for SHA-1/224/256/384/512
perl-Digest-SHA-5.71.1.el6.rfx (x86_64)

I imagine for those running 32-bit kernels the patch would be:

perl-Digest-SHA-PurePerl-5.48.1.el6.rf (noarch)

Here is the actual output before patch:

 ./build
Checking if the needed tools for CentOS release 6.5 (Final)
are available
ERROR: please install "Digest::SHA", otherwise, build
won't work.
I don't know distro CentOS release 6.5 (Final).
So, I can't provide you a hint with the package names. Be welcome to
contribute with a patch for media-build, by submitting a distro-specific
hint to linux-media@vger.kernel.org Build can't procceed as 1 dependency
is missing at ./build line 266.

