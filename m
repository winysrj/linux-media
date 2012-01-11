Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757896Ab2AKTtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 14:49:14 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0BJnDjU012514
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 14:49:14 -0500
Received: from shalem.localdomain (vpn1-6-138.ams2.redhat.com [10.36.6.138])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q0BJnChT008766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 14:49:13 -0500
Message-ID: <4F0DE800.4040805@redhat.com>
Date: Wed, 11 Jan 2012 20:50:24 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.3] More pwc cleanups and fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for some more pwc cleanups and fixes.

The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

   [media] [PATCH] don't reset the delivery system on DTV_CLEAR (2012-01-10 23:44:07 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.3

Hans de Goede (8):
       pwc: Make fps runtime configurable through s_parm, drop fps module param
       pwc: Make decoder data part of the main pwc struct
       pwc: Fix pixfmt handling
       pwc: Avoid sending mode info to the camera when it is not needed
       pwc: Avoid unnecessarily rebuilding the decoder tables
       pwc: Use one shared usb command buffer
       pwc: Remove dev_hint module parameter
       pwc: Simplify leds parameter parsing

  drivers/media/video/pwc/pwc-ctrl.c  |  231 +++++++++++++++--------------------
  drivers/media/video/pwc/pwc-dec1.c  |   16 +--
  drivers/media/video/pwc/pwc-dec1.h  |    6 +-
  drivers/media/video/pwc/pwc-dec23.c |   41 +++----
  drivers/media/video/pwc/pwc-dec23.h |    9 +-
  drivers/media/video/pwc/pwc-if.c    |  175 +++------------------------
  drivers/media/video/pwc/pwc-misc.c  |    1 -
  drivers/media/video/pwc/pwc-v4l.c   |   90 +++++++++++---
  drivers/media/video/pwc/pwc.h       |   14 ++-
  9 files changed, 227 insertions(+), 356 deletions(-)

Regards,

Hans
