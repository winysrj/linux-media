Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m36MJrPW023292
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 18:19:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m36MJchL024251
	for <video4linux-list@redhat.com>; Sun, 6 Apr 2008 18:19:38 -0400
Date: Sun, 6 Apr 2008 19:19:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20080406191911.68aed9c6@gaivota>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [GIT PATCHES] V4L/DVB new USB ID's for 2.6.25-rc8
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git pci_id_updates

For the following:

   - pvrusb2: add new usb pid for 73xx and 75xxx models

Those boards are about to be released by their vendor (Hauppauge). The already 
committed changes for pvrusb2 were meant to address those new devices. However, 
the vendor changed the usb sub ID's at the last moment. Those two patches adds 
the newer ID's to allow kernel to properly detect the devices.

Cheers,
Mauro.

---

 drivers/media/video/pvrusb2/pvrusb2-devattr.c |   35 +++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

Michael Krufky (2):
      V4L/DVB (7496): pvrusb2: add new usb pid for 75xxx models
      V4L/DVB (7497): pvrusb2: add new usb pid for 73xxx models

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
