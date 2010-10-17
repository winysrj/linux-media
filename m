Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:54845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403Ab0JQQ3l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 12:29:41 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9HGTe6k002035
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 12:29:40 -0400
Received: from [10.3.225.152] (vpn-225-152.phx2.redhat.com [10.3.225.152])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o9HGTdub002055
	for <linux-media@vger.kernel.org>; Sun, 17 Oct 2010 12:29:40 -0400
Message-ID: <4CBB2470.50405@redhat.com>
Date: Sun, 17 Oct 2010 14:29:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [ANNOUNCE] new experimental building system
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I received some comments from some developers that wanted to test their drivers
with the latest -stable kernel. After thinking for a while, I decided to do
a small test, packaging the current build system into a separate tree, without
any drivers, and providing a way to allow using it with the latest driver.

I added it at:
	http://git.linuxtv.org/mchehab/new_build.git

The current version is very raw, but people are free to send patches to improve it.

Usage:

git clone git://linuxtv.org/mchehab/new_build.git
cd new_build/linux
make tar DIR=<some dir with media -git tree>
make untar
cd ..

After that, it will work like the old -hg build system.

Notes:

1) There's not much compat stuff here. So, it will likely not work with
   legacy kernels. It will probably be fine to use it with the latest stable
   kernel, although I tested it only with 2.6.36-rc7.

2) For now, this is just an experience. I don't intend to maintain any
   out-of-tree building system, due to my lack of time for it. If this interests
   someone, feel free to candidate to maintain it.

3) It shouldn't be hard to support legacy kernels. All that it is needed is
   to have patches adding backports that don't fit at compat.h, and let the
   building system to apply them, depending on the kernel version.

If someone manifests interests on maintaining it, we probably may have some
script at linuxtv.org, generating daily tarballs with the latest drivers, to
be used by this build system.

Cheers,
Mauro
