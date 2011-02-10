Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36727 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab1BJEtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 23:49:41 -0500
Received: by wyb28 with SMTP id 28so949152wyb.19
        for <linux-media@vger.kernel.org>; Wed, 09 Feb 2011 20:49:40 -0800 (PST)
MIME-Version: 1.0
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 9 Feb 2011 20:49:19 -0800
Message-ID: <AANLkTi=YTyf=wTHz9L7XMf9APR=nOjawYARVMP9Y70Am@mail.gmail.com>
Subject: [GIT FIXES for 2.6.38] Fix double free of video_device in mem2mem_testdev
To: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,
please pull this fix for mem2mem_testdev, which should solve a bug
reported by Roland Kletzing a while ago.


The following changes since commit d3d373e0e3f51f335d8c722dd1340ab812fdf94b:

 Merge git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus
(2011-02-09 11:51:40 -0800)

are available in the git repository at:

 ssh://linuxtv.org/git/posciak/media_tree.git staging/for_v2.6.38rc

Pawel Osciak (1):
     [media] Fix double free of video_device in mem2mem_testdev

drivers/media/video/mem2mem_testdev.c |    1 -
1 files changed, 0 insertions(+), 1 deletions(-)

--
Thanks,
Pawel Osciak
