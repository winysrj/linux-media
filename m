Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab1GSKbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 06:31:53 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6JAVrnn028551
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 06:31:53 -0400
Received: from shalem.localdomain (vpn1-6-8.ams2.redhat.com [10.36.6.8])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6JAVp25030178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 06:31:52 -0400
Message-ID: <4E255D71.8050906@redhat.com>
Date: Tue, 19 Jul 2011 12:33:21 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 3.1] pwc: Add support for control events
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree to add support for control events to
the pwc driver. Note that this patch depends upon the patches
from hverkuils poll tree (and those patches are thus also
in my tree, but not part of this pull req).

The following changes since commit 30178e8623281063c18592a848cdcd71f78f603d:

   vivi: let vb2_poll handle events. (2011-07-18 13:07:28 +0200)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git media-for_v3.1

Hans de Goede (1):
       pwc: Add support for control events

  drivers/media/video/pwc/pwc-if.c  |   84 ++++++++++++++++---------------------
  drivers/media/video/pwc/pwc-v4l.c |   16 ++++++-
  drivers/media/video/pwc/pwc.h     |    4 ++
  3 files changed, 53 insertions(+), 51 deletions(-)

Regards,

Hans
