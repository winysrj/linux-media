Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64888 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab2AQJDD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 04:03:03 -0500
Received: by wgbdq11 with SMTP id dq11so1631392wgb.1
        for <linux-media@vger.kernel.org>; Tue, 17 Jan 2012 01:03:02 -0800 (PST)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: PULL request: remove superfluous DTV_CMDs
Date: Tue, 17 Jan 2012 10:02:59 +0100
Cc: linux-media@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201171002.59465.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

I fixed a warning caused by a commit made a long time ago in 
dvb_frontend.c . 

Thanks to Dan Carpenter for pointing this one out.

-----------------

The following changes since commit 
1e73fa5d56333230854ae9460579eb2fcee8af02:
  Mauro Carvalho Chehab (1):
        [media] stb6100: Properly retrieve symbol rate

are available in the git repository at:

  http://linuxtv.org/git/pb/media_tree.git staging/for_v3.3

Patrick Boettcher (1):
      [media] DVB-CORE: remove superfluous DTV_CMDs

 drivers/media/dvb/dvb-core/dvb_frontend.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)


best regards,
--
Patrick Boettcher

Kernel Labs Inc.
http://www.kernellabs.com/
