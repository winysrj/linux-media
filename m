Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1385 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717AbZKYOew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 09:34:52 -0500
Received: from tschai.localnet (cm-84.208.105.24.getinternet.no [84.208.105.24])
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id nAPEYrwS070165
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 25 Nov 2009 15:34:57 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: dvb valgrind patches?
Date: Wed, 25 Nov 2009 15:34:59 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251534.59479.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

In dvb-spec there are several valgrind patches that add support to valgrind for
the dvb ioctls. However, these patches no longer apply to the latest valgrind
(and probably haven't for a *very* long time), so unless someone wants to port
these to recent valgrind versions I propose to delete them in two weeks time.

I took a very quick look and it seems that these valgrind files would need to
be patched:

./include/vki/vki-linux.h
./coregrind/m_syswrap/syswrap-linux.c

Of course, if someone is going to port these patches to the latest valgrind,
then those patches should be mailed to the valgrind maintainer for inclusion
in valgrind itself. That's much better than trying to maintain them in our
tree.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
