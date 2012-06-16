Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43979 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2FPNQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 09:16:24 -0400
Date: Sat, 16 Jun 2012 16:16:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
	mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (12730): Add conexant cx25821 driver
Message-ID: <20120616131611.GA17802@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Palash Bandyopadhyay,

The patch 02b20b0b4cde: "V4L/DVB (12730): Add conexant cx25821
driver" from Sep 15, 2009, leads to the following warning:
drivers/media/video/cx25821/cx25821-i2c.c:310 cx25821_i2c_register()
	 error: memcpy() '&cx25821_i2c_algo_template' too small (24 vs 64)

   306          dprintk(1, "%s(bus = %d)\n", __func__, bus->nr);
   307  
   308          memcpy(&bus->i2c_adap, &cx25821_i2c_adap_template,
   309                 sizeof(bus->i2c_adap));
 > 310          memcpy(&bus->i2c_algo, &cx25821_i2c_algo_template,
   311                 sizeof(bus->i2c_algo));
   312          memcpy(&bus->i2c_client, &cx25821_i2c_client_template,
   313                 sizeof(bus->i2c_client));
   314  

The problem is that "bus->i2c_algo" is a i2c_algo_bit_data struct and
cx25821_i2c_algo_template is a i2c_algorithm struct.  They are different
sizes and the function pointers don't line up at all.  I don't see how
this can work at all.

regards,
dan carpenter

