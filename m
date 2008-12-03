Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3ITYQC011105
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:29:34 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mB3ITISF026523
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:29:19 -0500
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 3 Dec 2008 19:29:12 +0100
MIME-Version: 1.0
Message-Id: <200812031929.12660.tobias.lorenz@gmx.net>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mm-commits@vger.kernel.org, greg@kroah.com,
	mlord@pobox.com, lkml@rtr.ca, v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH] si470x: Support for DealExtreme
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

Mauro,

Please pull from http://linuxtv.org/hg/~tlorenz/v4l-dvb

for the following changeset:

01/01: Add USB ID for the Sil4701 radio from DealExtreme.
http://linuxtv.org/hg/~tlorenz/v4l-dvb?cmd=changeset;node=42f57f457d9d3a91d5f3966b59bfa87679ecb1c7


 Documentation/video4linux/si470x.txt |    1 +
 drivers/media/radio/radio-si470x.c   |    4 ++++
 2 files changed, 5 insertions(+)

Thanks,
Tobias
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
