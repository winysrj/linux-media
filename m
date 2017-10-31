Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47453 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932237AbdJaLDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 07:03:40 -0400
Date: Tue, 31 Oct 2017 14:02:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kbuild@01.org, Leon Luo <leonl@leopardimaging.com>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [ragnatech:media-tree 2807/2822] drivers/media/i2c/imx274.c:659
 imx274_regmap_util_write_table_8() error: uninitialized symbol 'err'.
Message-ID: <20171031110223.lk73lh6dpesgcg45@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://git.ragnatech.se/linux media-tree
head:   bbae615636155fa43a9b0fe0ea31c678984be864
commit: 0985dd306f727df6c0e71cd8a8eda93e8fa5206e [2807/2822] media: imx274: V4l2 driver for Sony imx274 CMOS sensor

drivers/media/i2c/imx274.c:659 imx274_regmap_util_write_table_8() error: uninitialized symbol 'err'.

git remote add ragnatech git://git.ragnatech.se/linux
git remote update ragnatech
git checkout 0985dd306f727df6c0e71cd8a8eda93e8fa5206e
vim +/err +659 drivers/media/i2c/imx274.c

0985dd30 Leon Luo 2017-10-05  621  
0985dd30 Leon Luo 2017-10-05  622  /*
0985dd30 Leon Luo 2017-10-05  623   * imx274_regmap_util_write_table_8 - Function for writing register table
0985dd30 Leon Luo 2017-10-05  624   * @regmap: Pointer to device reg map structure
0985dd30 Leon Luo 2017-10-05  625   * @table: Table containing register values
0985dd30 Leon Luo 2017-10-05  626   * @wait_ms_addr: Flag for performing delay
0985dd30 Leon Luo 2017-10-05  627   * @end_addr: Flag for incating end of table
0985dd30 Leon Luo 2017-10-05  628   *
0985dd30 Leon Luo 2017-10-05  629   * This is used to write register table into sensor's reg map.
0985dd30 Leon Luo 2017-10-05  630   *
0985dd30 Leon Luo 2017-10-05  631   * Return: 0 on success, errors otherwise
0985dd30 Leon Luo 2017-10-05  632   */
0985dd30 Leon Luo 2017-10-05  633  static int imx274_regmap_util_write_table_8(struct regmap *regmap,
0985dd30 Leon Luo 2017-10-05  634  					    const struct reg_8 table[],
0985dd30 Leon Luo 2017-10-05  635  					    u16 wait_ms_addr, u16 end_addr)
0985dd30 Leon Luo 2017-10-05  636  {
0985dd30 Leon Luo 2017-10-05  637  	int err;
0985dd30 Leon Luo 2017-10-05  638  	const struct reg_8 *next;
0985dd30 Leon Luo 2017-10-05  639  	u8 val;
0985dd30 Leon Luo 2017-10-05  640  
0985dd30 Leon Luo 2017-10-05  641  	int range_start = -1;
0985dd30 Leon Luo 2017-10-05  642  	int range_count = 0;
0985dd30 Leon Luo 2017-10-05  643  	u8 range_vals[16];
0985dd30 Leon Luo 2017-10-05  644  	int max_range_vals = ARRAY_SIZE(range_vals);
0985dd30 Leon Luo 2017-10-05  645  
0985dd30 Leon Luo 2017-10-05  646  	for (next = table;; next++) {
0985dd30 Leon Luo 2017-10-05  647  		if ((next->addr != range_start + range_count) ||
0985dd30 Leon Luo 2017-10-05  648  		    (next->addr == end_addr) ||
0985dd30 Leon Luo 2017-10-05  649  		    (next->addr == wait_ms_addr) ||
0985dd30 Leon Luo 2017-10-05  650  		    (range_count == max_range_vals)) {
0985dd30 Leon Luo 2017-10-05  651  			if (range_count == 1)
0985dd30 Leon Luo 2017-10-05  652  				err = regmap_write(regmap,
0985dd30 Leon Luo 2017-10-05  653  						   range_start, range_vals[0]);
0985dd30 Leon Luo 2017-10-05  654  			else if (range_count > 1)
0985dd30 Leon Luo 2017-10-05  655  				err = regmap_bulk_write(regmap, range_start,
0985dd30 Leon Luo 2017-10-05  656  							&range_vals[0],
0985dd30 Leon Luo 2017-10-05  657  							range_count);
0985dd30 Leon Luo 2017-10-05  658  
0985dd30 Leon Luo 2017-10-05 @659  			if (err)
0985dd30 Leon Luo 2017-10-05  660  				return err;
0985dd30 Leon Luo 2017-10-05  661  
0985dd30 Leon Luo 2017-10-05  662  			range_start = -1;
0985dd30 Leon Luo 2017-10-05  663  			range_count = 0;
0985dd30 Leon Luo 2017-10-05  664  
0985dd30 Leon Luo 2017-10-05  665  			/* Handle special address values */
0985dd30 Leon Luo 2017-10-05  666  			if (next->addr == end_addr)
0985dd30 Leon Luo 2017-10-05  667  				break;
0985dd30 Leon Luo 2017-10-05  668  
0985dd30 Leon Luo 2017-10-05  669  			if (next->addr == wait_ms_addr) {
0985dd30 Leon Luo 2017-10-05  670  				msleep_range(next->val);
0985dd30 Leon Luo 2017-10-05  671  				continue;
0985dd30 Leon Luo 2017-10-05  672  			}
0985dd30 Leon Luo 2017-10-05  673  		}
0985dd30 Leon Luo 2017-10-05  674  
0985dd30 Leon Luo 2017-10-05  675  		val = next->val;
0985dd30 Leon Luo 2017-10-05  676  
0985dd30 Leon Luo 2017-10-05  677  		if (range_start == -1)
0985dd30 Leon Luo 2017-10-05  678  			range_start = next->addr;
0985dd30 Leon Luo 2017-10-05  679  
0985dd30 Leon Luo 2017-10-05  680  		range_vals[range_count++] = val;
0985dd30 Leon Luo 2017-10-05  681  	}
0985dd30 Leon Luo 2017-10-05  682  	return 0;
0985dd30 Leon Luo 2017-10-05  683  }
0985dd30 Leon Luo 2017-10-05  684  

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
