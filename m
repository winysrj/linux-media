Return-path: <mchehab@pedra>
Received: from smtp204.alice.it ([82.57.200.100]:44509 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab1DUJvw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 05:51:52 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Drew Fisher <drew.m.fisher@gmail.com>
Subject: [PATCH 0/3] gspca_kinect fixup
Date: Thu, 21 Apr 2011 11:51:33 +0200
Message-Id: <1303379496-12899-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <4DADF1CB.4050504@redhat.com>
References: <4DADF1CB.4050504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

some incremental fixes for the gspca kinect driver, the first patch in 
the series by Drew Fisher addresses the issue Mauro was pointing out.

Thanks,
   Antonio

Antonio Ospite (1):
  gspca - kinect: fix comments referring to color camera

Drew Fisher (2):
  gspca - kinect: move communications buffers out of stack
  gspca - kinect: fix a typo s/steram/stream/

 drivers/media/video/gspca/kinect.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

-- 
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
