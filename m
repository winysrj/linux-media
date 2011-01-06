Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:18776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1AFLa0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 06:30:26 -0500
Date: Thu, 6 Jan 2011 09:28:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: moinejf@free.fr
Cc: stable@kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	gregkh@suse.de
Subject: [PATCH 0/4] gspca fix backports for 2.6.36
Message-ID: <20110106092836.14a0da68@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This patch series backport POWER INV fixes for sonixj sensors.

Jean,

I'm currently without any sensorj camera. Could you please test this backport?
Greg already backported two patches of this series. Those patches should be
applied after stable patches he sent yesterday (151/152 and 152/152).
All patches are at the ML.

Jean-Francois Moine (1):
  [media] gspca - sonixj: Better handling of the bridge registers 0x01
    and 0x17

Mauro Carvalho Chehab (3):
  [media] gspca - sonixj: Move bridge init to sd start
  [media] gspca - sonixj: Add the bit definitions of the bridge reg
    0x01 and 0x17
  [media] gspca - sonixj: Fix a bad probe exchange

 drivers/media/video/gspca/sonixj.c |  389 ++++++++++++++++--------------------
 1 files changed, 168 insertions(+), 221 deletions(-)

-- 
1.7.3.4

