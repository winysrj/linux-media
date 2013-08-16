Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm23-vm8.access.bullet.mail.bf1.yahoo.com ([216.109.115.167]:41954
	"EHLO nm23-vm8.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517Ab3HQAY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 20:24:56 -0400
Message-ID: <1376688948.72628.YahooMailNeo@web182201.mail.bf1.yahoo.com>
Date: Fri, 16 Aug 2013 14:35:48 -0700 (PDT)
From: Aurora Cormany <igamiro@sbcglobal.net>
Reply-To: Aurora Cormany <igamiro@sbcglobal.net>
Subject: [BUG REPORT] build script for media_build
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The build script for the media_build git contains hints for packages to be pre-installed before attempting to build the kernel drivers. The Ubuntu (and Debian) hints contains a recommendation for "libdigest-sha1-perl". This package is no longer available in either Ubuntu (since 10.10) or Debian Wheezy (stable). The package "libdigest-sha-perl" seems to be an acceptable substitute. I suggest the script be revised to include the available package.

Thanks,
Aurora C.

