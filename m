Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19483 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaIBVaQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Sep 2014 17:30:16 -0400
Date: Wed, 03 Sep 2014 05:29:15 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 495/499]
 drivers/media/platform/vivid/vivid-core.c:834:2: error: implicit
 declaration of function 'vzalloc'
Message-ID: <540636ab.Glv0GkfI2qZHPEUo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

First bad commit (maybe != root cause):

tree:   git://linuxtv.org/media_tree.git master
head:   6c1c423a54b5b3a6c9c9561c7ef32aee0fda7253
commit: e75420dd25bc9d7b6f4e3b4c4f6c778b610c8cda [495/499] [media] vivid: enable the vivid driver
config: make ARCH=ia64 allmodconfig

All error/warnings:

   drivers/media/platform/vivid/vivid-core.c: In function 'vivid_create_instance':
>> drivers/media/platform/vivid/vivid-core.c:834:2: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
     dev->scaled_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
     ^
>> drivers/media/platform/vivid/vivid-core.c:834:19: warning: assignment makes pointer from integer without a cast
     dev->scaled_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
                      ^
>> drivers/media/platform/vivid/vivid-core.c:837:20: warning: assignment makes pointer from integer without a cast
     dev->blended_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
                       ^
>> drivers/media/platform/vivid/vivid-core.c:842:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
     dev->edid = vmalloc(256 * 128);
     ^
>> drivers/media/platform/vivid/vivid-core.c:842:12: warning: assignment makes pointer from integer without a cast
     dev->edid = vmalloc(256 * 128);
               ^
>> drivers/media/platform/vivid/vivid-core.c:1276:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
     vfree(dev->scaled_line);
     ^
   cc1: some warnings being treated as errors
--
   drivers/media/platform/vivid/vivid-vbi-gen.c: In function 'vivid_vbi_gen_sliced':
>> drivers/media/platform/vivid/vivid-vbi-gen.c:206:2: error: implicit declaration of function 'memset' [-Werror=implicit-function-declaration]
     memset(vbi->data, 0, sizeof(vbi->data));
     ^
>> drivers/media/platform/vivid/vivid-vbi-gen.c:206:2: warning: incompatible implicit declaration of built-in function 'memset'
   cc1: some warnings being treated as errors
--
   drivers/media/platform/vivid/vivid-vid-cap.c: In function 'vidioc_s_fmt_vid_overlay':
>> drivers/media/platform/vivid/vivid-vid-cap.c:1109:3: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
      new_bitmap = vzalloc(bitmap_size);
      ^
>> drivers/media/platform/vivid/vivid-vid-cap.c:1109:14: warning: assignment makes pointer from integer without a cast
      new_bitmap = vzalloc(bitmap_size);
                 ^
>> drivers/media/platform/vivid/vivid-vid-cap.c:1114:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
       vfree(new_bitmap);
       ^
   cc1: some warnings being treated as errors
--
   drivers/media/platform/vivid/vivid-rds-gen.c: In function 'vivid_rds_gen_fill':
>> drivers/media/platform/vivid/vivid-rds-gen.c:158:3: error: implicit declaration of function 'strlcpy' [-Werror=implicit-function-declaration]
      strlcpy(rds->radiotext,
      ^
   cc1: some warnings being treated as errors
--
   drivers/media/platform/vivid/vivid-tpg.c: In function 'tpg_alloc':
>> drivers/media/platform/vivid/vivid-tpg.c:125:4: error: implicit declaration of function 'vzalloc' [-Werror=implicit-function-declaration]
       tpg->lines[pat][plane] = vzalloc(max_w * 2 * pixelsz);
       ^
>> drivers/media/platform/vivid/vivid-tpg.c:125:27: warning: assignment makes pointer from integer without a cast
       tpg->lines[pat][plane] = vzalloc(max_w * 2 * pixelsz);
                              ^
>> drivers/media/platform/vivid/vivid-tpg.c:133:29: warning: assignment makes pointer from integer without a cast
      tpg->contrast_line[plane] = vzalloc(max_w * pixelsz);
                                ^
>> drivers/media/platform/vivid/vivid-tpg.c:136:26: warning: assignment makes pointer from integer without a cast
      tpg->black_line[plane] = vzalloc(max_w * pixelsz);
                             ^
>> drivers/media/platform/vivid/vivid-tpg.c:139:27: warning: assignment makes pointer from integer without a cast
      tpg->random_line[plane] = vzalloc(max_w * pixelsz);
                              ^
   drivers/media/platform/vivid/vivid-tpg.c: In function 'tpg_free':
>> drivers/media/platform/vivid/vivid-tpg.c:153:4: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
       vfree(tpg->lines[pat][plane]);
       ^
   cc1: some warnings being treated as errors

vim +/vzalloc +834 drivers/media/platform/vivid/vivid-core.c

c88a96b0 Hans Verkuil 2014-08-25  828  				     V4L2_CAP_READWRITE;
c88a96b0 Hans Verkuil 2014-08-25  829  
c88a96b0 Hans Verkuil 2014-08-25  830  	/* initialize the test pattern generator */
c88a96b0 Hans Verkuil 2014-08-25  831  	tpg_init(&dev->tpg, 640, 360);
c88a96b0 Hans Verkuil 2014-08-25  832  	if (tpg_alloc(&dev->tpg, MAX_ZOOM * MAX_WIDTH))
c88a96b0 Hans Verkuil 2014-08-25  833  		goto free_dev;
c88a96b0 Hans Verkuil 2014-08-25 @834  	dev->scaled_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
c88a96b0 Hans Verkuil 2014-08-25  835  	if (!dev->scaled_line)
c88a96b0 Hans Verkuil 2014-08-25  836  		goto free_dev;
c88a96b0 Hans Verkuil 2014-08-25 @837  	dev->blended_line = vzalloc(MAX_ZOOM * MAX_WIDTH);
c88a96b0 Hans Verkuil 2014-08-25  838  	if (!dev->blended_line)
c88a96b0 Hans Verkuil 2014-08-25  839  		goto free_dev;
c88a96b0 Hans Verkuil 2014-08-25  840  
c88a96b0 Hans Verkuil 2014-08-25  841  	/* load the edid */
c88a96b0 Hans Verkuil 2014-08-25 @842  	dev->edid = vmalloc(256 * 128);
c88a96b0 Hans Verkuil 2014-08-25  843  	if (!dev->edid)
c88a96b0 Hans Verkuil 2014-08-25  844  		goto free_dev;
c88a96b0 Hans Verkuil 2014-08-25  845  

:::::: The code at line 834 was first introduced by commit
:::::: c88a96b023d8239b2019f93dac42c02e6fd0dff0 [media] vivid: add core driver code

:::::: TO: Hans Verkuil <hans.verkuil@cisco.com>
:::::: CC: Mauro Carvalho Chehab <m.chehab@samsung.com>

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
