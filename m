Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:56773 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751683AbeDVSFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 14:05:09 -0400
Date: Mon, 23 Apr 2018 02:05:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kbuild-all@01.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org
Subject: [RFC PATCH] sound, media: array_find() can be static
Message-ID: <20180422180503.GA27818@lkp-sb04.lkp.intel.com>
References: <3f4d8ae83a91c765581d9cbbd1e436b6871368fa.1524227382.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f4d8ae83a91c765581d9cbbd1e436b6871368fa.1524227382.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fixes: dbd775375e7d ("sound, media: allow building ISA drivers it with COMPILE_TEST")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cmi8328.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/isa/cmi8328.c b/sound/isa/cmi8328.c
index d09e456..de6ef1b 100644
--- a/sound/isa/cmi8328.c
+++ b/sound/isa/cmi8328.c
@@ -192,7 +192,7 @@ static int snd_cmi8328_mixer(struct snd_wss *chip)
 }
 
 /* find index of an item in "-1"-ended array */
-int array_find(int array[], int item)
+static int array_find(int array[], int item)
 {
 	int i;
 
@@ -203,7 +203,7 @@ int array_find(int array[], int item)
 	return -1;
 }
 /* the same for long */
-int array_find_l(long array[], long item)
+static int array_find_l(long array[], long item)
 {
 	int i;
 
