Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab1GXPUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 11:20:13 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6OFKDUc003356
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 11:20:13 -0400
Received: from shalem.localdomain (vpn1-6-98.ams2.redhat.com [10.36.6.98])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p6OFKB56024160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 11:20:13 -0400
Message-ID: <4E2C388E.30402@redhat.com>
Date: Sun, 24 Jul 2011 17:21:50 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT FIXES FOR 3.1] pwc: various fixes
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 2 bug fixes patches + support for
control events for the pwc driver. Note that the control events
patch depends upon the patches from hverkuils poll tree
(and those patches are thus also in my tree, but not part of this
pull req).

The following changes since commit 30178e8623281063c18592a848cdcd71f78f603d:

   vivi: let vb2_poll handle events. (2011-07-18 13:07:28 +0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.1

Dan Carpenter (1):
       pwc: precedence bug in pwc_init_controls()

Hans de Goede (2):
       pwc: Add support for control events
       pwc: properly mark device_hint as unused in all probe error paths

  drivers/media/video/pwc/pwc-if.c  |   79 ++++++++++++++----------------------
  drivers/media/video/pwc/pwc-v4l.c |   18 +++++++--
  drivers/media/video/pwc/pwc.h     |    4 ++
  3 files changed, 49 insertions(+), 52 deletions(-)

Regards,

Hans
