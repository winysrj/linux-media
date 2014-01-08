Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17817 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082AbaAHJJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 04:09:34 -0500
Date: Wed, 8 Jan 2014 12:09:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: a.hajda@samsung.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] Add driver for Samsung S5K5BAF camera sensor
Message-ID: <20140108090942.GA28296@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andrzej Hajda,

This is a semi-automatic email about new static checker warnings.

The patch 7d459937dc09: "[media] Add driver for Samsung S5K5BAF 
camera sensor" from Dec 5, 2013, leads to the following Smatch 
complaint:

drivers/media/i2c/s5k5baf.c:554 s5k5baf_fw_get_seq()
	 warn: variable dereferenced before check 'fw' (see line 551)

drivers/media/i2c/s5k5baf.c
   550		struct s5k5baf_fw *fw = state->fw;
   551		u16 *data = fw->data + 2 * fw->count;
                                           ^^^^^^^^^
Dereference.

   552		int i;
   553	
   554		if (fw == NULL)
                    ^^^^^^^^^^
Check.

   555			return NULL;
   556	

regards,
dan carpenter
