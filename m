Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:21134 "EHLO
	mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbcDKFTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2016 01:19:39 -0400
To: sasha.levin@oracle.com
Cc: linux-media@vger.kernel.org, stable@vger.kernel.org,
	hverkuil@xs4all.nl, oneukum@suse.com, vdronov@redhat.com,
	mchehab@osg.samsung.com, ralf@spenneberg.net
From: Yuki Machida <machida.yuki@jp.fujitsu.com>
Subject: Backport a Security Fix for CVE-2015-7833 to v4.1
Message-ID: <570B33E6.40705@jp.fujitsu.com>
Date: Mon, 11 Apr 2016 14:19:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sasha,

I conformed that these patches for CVE-2015-7833 not applied at v4.1.21.
588afcc1c0e45358159090d95bf7b246fb67565
fa52bd506f274b7619955917abfde355e3d19ff
Could you please apply this CVE-2015-7833 fix for 4.1-stable ?

References:
https://security-tracker.debian.org/tracker/CVE-2015-7833
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=588afcc1c0e45358159090d95bf7b246fb67565f
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fa52bd506f274b7619955917abfde355e3d19ffe

Regards,
Yuki Machida
