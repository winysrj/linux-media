Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:30842 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2ADGp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 01:45:29 -0500
Date: Wed, 4 Jan 2012 09:45:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
Message-ID: <20120104064521.GA29273@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

This is a semi-automatic email about new static checker warnings.

The patch a7d44baaed0a: "[media] cx23885-dvb: Remove a dirty hack 
that would require DVBv3" from Dec 26, 2011, leads to the following 
Smatch complaint:

drivers/media/video/cx23885/cx23885-dvb.c +135 cx23885_dvb_gate_ctrl()
	 error: we previously assumed 'fe' could be null (see line 128)

drivers/media/video/cx23885/cx23885-dvb.c
   127	
   128		if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
                    ^^
Old condition.

   129			fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
   130	
   131		/*
   132		 * FIXME: Improve this path to avoid calling the
   133		 * cx23885_dvb_set_frontend() every time it passes here.
   134		 */
   135		cx23885_dvb_set_frontend(fe->dvb.frontend);
                                         ^^^^
New dereference.

   136	}
   137	

regards,
dan carpenter

