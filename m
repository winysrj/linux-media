Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:31389 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758414Ab2EOIs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 04:48:57 -0400
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4F8muQ9026533
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 15 May 2012 08:48:56 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q4F8mtdh007679
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 15 May 2012 08:48:55 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q4F8mt61018702
	for <linux-media@vger.kernel.org>; Tue, 15 May 2012 03:48:55 -0500
Date: Tue, 15 May 2012 11:48:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-media@vger.kernel.org
Subject: re: [media] cx23885-dvb: Remove a dirty hack that would require DVBv3
Message-ID: <20120515084847.GD30265@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I'm working some new Smatch stuff and sending bug reports for old
code.  -Dan

---
This is a semi-automatic email about new static checker warnings.

The patch a7d44baaed0a: "[media] cx23885-dvb: Remove a dirty hack 
that would require DVBv3" from Dec 26, 2011, leads to the following 
Smatch complaint:

drivers/media/video/cx23885/cx23885-dvb.c:137 cx23885_dvb_gate_ctrl()
	 error: we previously assumed 'fe->dvb.frontend' could be null (see line 130)

drivers/media/video/cx23885/cx23885-dvb.c
   129	
   130		if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
                    ^^^^^^^^^^^^^^^^^^^^^^
Old check.

   131			fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
   132	
   133		/*
   134		 * FIXME: Improve this path to avoid calling the
   135		 * cx23885_dvb_set_frontend() every time it passes here.
   136		 */
   137		cx23885_dvb_set_frontend(fe->dvb.frontend);
                                         ^^^^^^^^^^^^^^^^
New call to cx23885_dvb_set_frontend().  If "fe->dvb.frontend" is NULL
then we will oops in cx23885_dvb_set_frontend().  Also if "fe" is NULL
we'll oops right here.

   138	}
   139	

regards,
dan carpenter

