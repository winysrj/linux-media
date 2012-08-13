Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:22842 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2HMPXT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 11:23:19 -0400
Date: Mon, 13 Aug 2012 18:23:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] s2255drv: remove V4L2_FL_LOCK_ALL_FOPS
Message-ID: <20120813152306.GA12021@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

This is a semi-automatic email about new static checker warnings.

The patch 0e1f0edfdd25: "[media] s2255drv: remove 
V4L2_FL_LOCK_ALL_FOPS" from Jun 24, 2012, leads to the following 
Smatch complaint:

drivers/media/video/s2255drv.c:1867 s2255_mmap_v4l()
	 warn: variable dereferenced before check 'fh' (see line 1864)

drivers/media/video/s2255drv.c
  1863		struct s2255_fh *fh = file->private_data;
  1864		struct s2255_dev *dev = fh->dev;
                                        ^^^^^^^
New dereference.

  1865		int ret;
  1866	
  1867		if (!fh)
                    ^^^
Old check.

  1868			return -ENODEV;
  1869		dprintk(4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);

regards,
dan carpenter

