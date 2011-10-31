Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932848Ab1JaMae (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Oct 2011 08:30:34 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9VCUYlf001272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 08:30:34 -0400
Received: from shalem.localdomain (vpn1-4-232.ams2.redhat.com [10.36.4.232])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p9VCUWPH016637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 31 Oct 2011 08:30:33 -0400
Message-ID: <4EAE94FE.6020600@redhat.com>
Date: Mon, 31 Oct 2011 13:30:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.2] pwc driver ctrl events + fixes + pac207 exposure
 fix
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for the pwc ctrl-event changes +
various fixes as well as the long expected pac207 exposure fix:

The following changes since commit 9e9e52f85fac877344e1a5bf92b41c5450a8d2e5:

   vivi: let vb2_poll handle events. (2011-10-06 14:45:26 +0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.2

Hans de Goede (7):
       pwc: Add support for control events
       pwc: properly mark device_hint as unused in all probe error paths
       pwc: Make auto white balance speed and delay available as v4l2 controls
       pwc: rework locking
       pwc: poll(): Check that the device has not beem claimed for streaming already
       pwc: read new preset values when changing awb control to a preset
       gspca_pac207: Raise max exposure + various autogain setting tweaks

  drivers/media/video/gspca/pac207.c  |   10 +-
  drivers/media/video/pwc/pwc-ctrl.c  |  134 +++++++++++++++---------------
  drivers/media/video/pwc/pwc-dec23.c |    7 ++
  drivers/media/video/pwc/pwc-dec23.h |    2 +
  drivers/media/video/pwc/pwc-if.c    |  155 ++++++++++++++++++-----------------
  drivers/media/video/pwc/pwc-v4l.c   |  155 ++++++++++++++++++++++++-----------
  drivers/media/video/pwc/pwc.h       |   11 ++-
  7 files changed, 275 insertions(+), 199 deletions(-)

Thanks & Regards,

Hans
