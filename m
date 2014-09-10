Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaIJODs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 10:03:48 -0400
Message-ID: <54105A40.5060701@redhat.com>
Date: Wed, 10 Sep 2014 16:03:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Morgan Phillips <winter2718@gmail.com>
Subject: [PULL patches for 3.18]: 2 more gspca cleanup patches
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Please pull from my tree for 2 minor gspca cleanup patches:

The following changes since commit f5281fc81e9a0a3e80b78720c5ae2ed06da3bfae:

  [media] vpif: Fix compilation with allmodconfig (2014-09-09 18:08:08 -0300)

are available in the git repository at:

  git://linuxtv.org/hgoede/gspca.git media-for_v3.18

for you to fetch changes up to 5c0643f980be87fde6b98436776cd682bad3c069:

  sn9c20x: fix checkpatch warning: sizeof cmatrix should be sizeof(cmatrix) (2014-09-10 15:51:50 +0200)

----------------------------------------------------------------
Morgan Phillips (2):
      sn9c20x.c: fix checkpatch error: that open brace { should be on the previous line
      sn9c20x: fix checkpatch warning: sizeof cmatrix should be sizeof(cmatrix)

 drivers/media/usb/gspca/sn9c20x.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Thanks & Regards,

Hans
