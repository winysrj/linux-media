Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:17684 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LMIM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 03:12:26 -0500
Date: Tue, 13 Dec 2011 11:12:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] tm6000: rewrite IR support
Message-ID: <20111213081214.GA28464@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

This is a semi-automatic email about new static checker warnings.

The patch 4a83b0115066: "[media] tm6000: rewrite IR support" from Nov 
29, 2011, leads to the following Smatch complaint:

drivers/media/video/tm6000/tm6000-input.c +327 __tm6000_ir_int_start()
	 warn: variable dereferenced before check 'ir' (see line 323)

drivers/media/video/tm6000/tm6000-input.c
   322		struct tm6000_IR *ir = rc->priv;
   323		struct tm6000_core *dev = ir->dev;
                                          ^^^^^^^
New dereference.

   324		int pipe, size;
   325		int err = -ENOMEM;
   326	
   327		if (!ir)
                ^^^^^^^^
Old check.

   328			return -ENODEV;
   329	

regards,
dan carpenter

