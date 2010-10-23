Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:2334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab0JWTlI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 15:41:08 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9NJf8tV020319
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 23 Oct 2010 15:41:08 -0400
Date: Sat, 23 Oct 2010 15:41:07 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/3] imon IR driver fixups
Message-ID: <20101023194107.GB4825@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Three minor imon IR driver fixups. Well, the first isn't so minor, since
without it, the imon driver can wedge your system. Getting ir_input_dev
(or at least try to get it) from the mouse input dev instead of the
remote input dev is bad... Then a minor cleanup patch and a modparam
option fixup.

Jarod Wilson (3):
	imon: fix my egregious brown paper bag w/rdev/idev split
	imon: remove redundant change_protocol call
	imon: fix nomouse modprobe option

 drivers/media/IR/imon.c |   48  +++++++++++++++++-----------------------------
  1 files changed, 18 insertions(+), 30 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

