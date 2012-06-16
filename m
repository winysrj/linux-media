Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnxtsmtp1.conexant.com ([198.62.9.252]:18838 "EHLO
	Cnxtsmtp1.conexant.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab2FPPzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 11:55:51 -0400
From: "Palash Bandyopadhyay" <Palash.Bandyopadhyay@conexant.com>
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"mchehab@redhat.com" <mchehab@redhat.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Sat, 16 Jun 2012 08:15:33 -0700
Subject: RE: V4L/DVB (12730): Add conexant cx25821 driver
Message-ID: <34B38BE41EDBA046A4AFBB591FA311320509E980E9@NBMBX01.bbnet.ad>
References: <20120616131611.GA17802@elgon.mountain>
In-Reply-To: <20120616131611.GA17802@elgon.mountain>
Content-Language: en-US
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Dan.

  Let me take a look and get back to you.

Rgds,
Palash
________________________________________
From: Dan Carpenter [dan.carpenter@oracle.com]
Sent: Saturday, June 16, 2012 6:16 AM
To: Palash Bandyopadhyay; mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (12730): Add conexant cx25821 driver

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
Conexant E-mail Firewall (Conexant.Com) made the following annotations
---------------------------------------------------------------------
********************** Legal Disclaimer **************************** 

"This email may contain confidential and privileged material for the sole use of the intended recipient. Any unauthorized review, use or distribution by others is strictly prohibited. If you have received the message in error, please advise the sender by reply email and delete the message. Thank you." 

********************************************************************** 

---------------------------------------------------------------------

