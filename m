Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbbCBNaf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 08:30:35 -0500
Message-ID: <54F465BF.4090804@redhat.com>
Date: Mon, 02 Mar 2015 14:29:35 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PULL fixes for 4.0]: gspca build fixes
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Here is a small build-fix for gspca for 4.0.

The following changes since commit a3dfc6d925ca1bbd1a228253acb93f08657bad25:

   [media] dvb-usb: create one media_dev per adapter (2015-02-26 09:52:26 -0300)

are available in the git repository at:

   git://linuxtv.org/hgoede/gspca.git media-for_v4.0

for you to fetch changes up to 4bc25799cb52f3e5f3084adb7be8cd2186905282:

   media: fix gspca drivers build dependencies (2015-03-02 14:23:49 +0100)

----------------------------------------------------------------
Randy Dunlap (1):
       media: fix gspca drivers build dependencies

  drivers/media/usb/gspca/Kconfig | 1 +
  1 file changed, 1 insertion(+)

Thanks & Regards,

Hans
