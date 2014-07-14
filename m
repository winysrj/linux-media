Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaGNKZc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 06:25:32 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6EAPUXw012911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 14 Jul 2014 06:25:31 -0400
Received: from shalem.localdomain (vpn1-7-203.ams2.redhat.com [10.36.7.203])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s6EAPTNl023427
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 14 Jul 2014 06:25:30 -0400
Message-ID: <53C3B018.3000503@redhat.com>
Date: Mon, 14 Jul 2014 12:25:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PULL patches for 3.17]: New gspca_pac7302 usb-id + qce button fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 2 small fixes, a nw gspca_pac7302 usb-id + qce button fix.
Note this supersedes my previous pull-req for just the new usb-id.

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks (2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.17

for you to fetch changes up to d2cfd7d0ce530928dfacd5cca0a544e1b071e925:

  gspca_pac7302: Add new usb-id for Genius i-Look 317 (2014-07-09 11:20:44 +0200)

----------------------------------------------------------------
Hans de Goede (1):
      gspca_pac7302: Add new usb-id for Genius i-Look 317

 drivers/media/usb/gspca/pac7302.c | 1 +
 1 file changed, 1 insertion(+)

Thanks & Regards,

Hans
