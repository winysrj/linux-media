Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3687 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab1ARUEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 15:04:00 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr14.xs4all.nl (8.13.8/8.13.8) with ESMTP id p0IK3s74076517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 18 Jan 2011 21:03:59 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Compile error fix
Date: Tue, 18 Jan 2011 21:03:49 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182103.49349.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

That beautiful 'OK' from the daily build disappeared again. This should bring
it back :-)

Regards,

	Hans

The following changes since commit fd4564a8c4f23b5ea6526180898ca2aedda2444e:
  Jarod Wilson (1):
        [media] staging/lirc: fix mem leaks and ptr err usage

are available in the git repository at:

  ssh://linuxtv.org/git/hverkuil/media_tree.git cxd2099

Hans Verkuil (1):
      cxd2099: fix 'multiple definition' compile errors

 drivers/staging/cxd2099/cxd2099.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
