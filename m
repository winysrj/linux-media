Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:19367 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036Ab2EQHKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 03:10:55 -0400
Date: Thu, 17 May 2012 10:10:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-media@vger.kernel.org
Cc: abraham.manu@gmail.com
Subject: bug report: null dereference in error handling in mantis_dvb_init()
Message-ID: <20120517071051.GF14660@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm working on some new Smatch stuff and so I'm finding old bugs and
emailing bug reports.

----
This is a semi-automatic email about new static checker warnings.

The patch 68fe255cd15c: "V4L/DVB (13799): [Mantis] Unregister 
frontend" from Dec 4, 2009, leads to the following Smatch complaint:

drivers/media/dvb/mantis/mantis_dvb.c:251 mantis_dvb_init()
	 error: we previously assumed 'mantis->fe' could be null (see line 228)

drivers/media/dvb/mantis/mantis_dvb.c
   227			} else {
   228				if (mantis->fe == NULL) {
   229					dprintk(MANTIS_ERROR, 1, "FE <NULL>");
   230					goto err5;

"mantis->fe" is NULL on this path.

   231				}
   232	
   233				if (dvb_register_frontend(&mantis->dvb_adapter, mantis->fe)) {
   234					dprintk(MANTIS_ERROR, 1, "ERROR: Frontend registration failed");
   235	
   236					if (mantis->fe->ops.release)
   237						mantis->fe->ops.release(mantis->fe);
   238	
   239					mantis->fe = NULL;

And here.

   240					goto err5;
   241				}
   242			}
   243		}
   244	
   245		return 0;
   246	
   247		/* Error conditions ..	*/
   248	err5:
   249		tasklet_kill(&mantis->tasklet);
   250		dvb_net_release(&mantis->dvbnet);
   251		dvb_unregister_frontend(mantis->fe);
                ^^^^^^^^^^^^^^^^^^^^^^^
This new call to dvb_unregister_frontend() was added but it can't handle
NULL pointers.

   252		dvb_frontend_detach(mantis->fe);
   253	err4:

regards,
dan carpenter

