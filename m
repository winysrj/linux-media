Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:19475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1CNItr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 04:49:47 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p2E8nlJV001541
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 04:49:47 -0400
Received: from shalem.localdomain (vpn2-8-182.ams2.redhat.com [10.36.8.182])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p2E8nj56016316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 04:49:47 -0400
Message-ID: <4D7DD721.3060804@redhat.com>
Date: Mon, 14 Mar 2011 09:51:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PATCHES FOR 2.6.39] Add support for cpia1 camera button
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Please pull from my gspca tree, for a single patch adding
support for the button on cpia1 based cameras.

The following changes since commit 41f3becb7bef489f9e8c35284dd88a1ff59b190c:

   [media] V4L DocBook: update V4L2 version (2011-03-11 18:09:02 -0300)

are available in the git repository at:
   git://linuxtv.org/hgoede/gspca.git gspca-for_v2.6.39

Hans de Goede (1):
       gspca_cpia1: Add support for button

  drivers/media/video/gspca/cpia1.c |   31 ++++++++++++++++++++++++++-----
  1 files changed, 26 insertions(+), 5 deletions(-)

Thanks,

Hans
