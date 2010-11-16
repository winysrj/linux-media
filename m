Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0KPQE3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 11:04:29 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAGG4SvX002308
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 11:04:29 -0500
Received: from shalem.localdomain (vpn1-6-110.ams2.redhat.com [10.36.6.110])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oAGG4PmK001262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 16 Nov 2010 11:04:28 -0500
Message-ID: <4CE2ABED.3080009@redhat.com>
Date: Tue, 16 Nov 2010 17:06:05 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.38] Fixes for driver pwc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

While investigating the following bug:
https://bugzilla.redhat.com/show_bug.cgi?id=624103

I found several errors in the handling of isoc transfers in
the pwc driver. The fixes in this pull request fix these.

Even with this fixed, the pwc driver is still far from ideal
in various places, esp. plug / unplug handling. If I feel like
it I may rewrite it as a gspca sub driver in the near future.

The following changes since commit 552faf8580766b6fc944cb966f690ed0624a5564:

   [media] mfd: Add timberdale video-in driver to timberdale (2010-11-16 12:06:58 -0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git gspca-for_v2.6.38

Hans de Goede (3):
       pwc: do not start isoc stream on /dev/video open
       pwc: Also set alt setting to alt0 when no error occured
       pwc: failure to submit an urb is a fatal error

  drivers/media/video/pwc/pwc-ctrl.c |    7 +++-
  drivers/media/video/pwc/pwc-if.c   |   65 +++++++++++------------------------
  drivers/media/video/pwc/pwc-v4l.c  |   13 ++++---
  drivers/media/video/pwc/pwc.h      |    1 -
  4 files changed, 34 insertions(+), 52 deletions(-)

Regards,

Hans

