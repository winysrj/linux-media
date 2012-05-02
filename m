Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:56648 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab2EBHLA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 May 2012 03:11:00 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:9ce4])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 8F6BC9400EF
	for <linux-media@vger.kernel.org>; Wed,  2 May 2012 09:10:54 +0200 (CEST)
Date: Wed, 2 May 2012 09:12:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 3.4] gspca for_v3.4
Message-ID: <20120502091205.115daf99@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 976a87b9ce3172065e21f0d136353a01df06d0d6:

  [media] gspca - sn9c20x: Change the exposure setting of Omnivision sensors (2012-04-09 14:22:52 -0300)

are available in the git repository at:

  git://linuxtv.org/jfrancois/gspca.git for_v3.4

for you to fetch changes up to 3f46715c09b017bfdfa8c0f5ea284d42a9c213a2:

  gspca - sonixj: Fix a zero divide in isoc interrupt (2012-05-02 09:05:18 +0200)

----------------------------------------------------------------
Jean-François Moine (1):
      gspca - sonixj: Fix a zero divide in isoc interrupt

 drivers/media/video/gspca/sonixj.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
