Return-path: <linux-media-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:59633 "EHLO
	mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbcDFCnw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2016 22:43:52 -0400
To: sasha.levin@oracle.com
From: Yuki Machida <machida.yuki@jp.fujitsu.com>
Subject: Security Fix for CVE-2015-7833
Cc: linux-media@vger.kernel.org, stable@vger.kernel.org
Message-ID: <570477DE.30705@jp.fujitsu.com>
Date: Wed, 6 Apr 2016 11:43:42 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sasha,

I conformed that these patches for CVE-2015-7833 not applied at v4.1.20.
588afcc1c0e45358159090d95bf7b246fb67565
fa52bd506f274b7619955917abfde355e3d19ff
Could you please apply this CVE-2015-7833 fix for 4.1-stable ?

References:
https://security-tracker.debian.org/tracker/CVE-2015-7833
http://git.linuxtv.org/cgit.cgi/media_tree.git/commit?id=588afcc1c0e45358159090d95bf7b246fb67565
http://git.linuxtv.org/cgit.cgi/media_tree.git/commit?id=fa52bd506f274b7619955917abfde355e3d19ff

Regards,
Yuki Machida
