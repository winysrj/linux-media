Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe09.c2i.net ([212.247.155.2]:40713 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933507Ab2AKSNf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 13:13:35 -0500
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe09.swip.net (CommuniGate Pro SMTP 5.4.2)
  with ESMTPA id 52778637 for linux-media@vger.kernel.org; Wed, 11 Jan 2012 19:13:31 +0100
From: Hans Petter Selasky <hselasky@c2i.net>
To: linux-media@vger.kernel.org
Subject: [Build log] FreeBSD 8-stable for staging/v3.2 branch
Date: Wed, 11 Jan 2012 19:11:16 +0100
References: <201111082224.00813.hselasky@c2i.net>
In-Reply-To: <201111082224.00813.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111911.16927.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The following patches are used to make the media tree code compile under 
FreeBSD 8-stable:

http://hselasky.homeunix.org:8192/media_tree_patches_freebsd.txt

Please have a look and see if some of these should be included in the default 
media tree git. Some patches are about renaming functions so that they don't 
overlap existing functions in the Linux kernel.

The build log including warnings is given here:

http://hselasky.homeunix.org:8192/media_tree_build_log_freebsd.txt.gz

--HPS
