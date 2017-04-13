Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41243 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdDMJri (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 05:47:38 -0400
Date: Thu, 13 Apr 2017 12:47:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] vp702x: comment dead code
Message-ID: <20170413094719.GA26666@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro Carvalho Chehab,

The patch 269d91f53fe3: "[media] vp702x: comment dead code" from Apr
29, 2015, leads to the following static checker warning:

	drivers/media/usb/dvb-usb/dvb-usb-remote.c:128 legacy_dvb_usb_read_remote_control()
	error: uninitialized symbol 'state'.

drivers/media/usb/dvb-usb/dvb-usb-remote.c
   108  static void legacy_dvb_usb_read_remote_control(struct work_struct *work)
   109  {
   110          struct dvb_usb_device *d =
   111                  container_of(work, struct dvb_usb_device, rc_query_work.work);
   112          u32 event;
   113          int state;
   114  
   115          /* TODO: need a lock here.  We can simply skip checking for the remote control
   116             if we're busy. */
   117  
   118          /* when the parameter has been set to 1 via sysfs while the driver was running */
   119          if (dvb_usb_disable_rc_polling)
   120                  return;
   121  
   122          if (d->props.rc.legacy.rc_query(d,&event,&state)) {
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^
This sometimes returns zero without doing anything like in
vp702x_rc_query().

   123                  err("error while querying for an remote control event.");
   124                  goto schedule;
   125          }
   126  
   127  
   128          switch (state) {
   129                  case REMOTE_NO_KEY_PRESSED:
   130                          break;
   131                  case REMOTE_KEY_PRESSED:
   132                          deb_rc("key pressed\n");
   133                          d->last_event = event;
   134                  case REMOTE_KEY_REPEAT:
   135                          deb_rc("key repeated\n");
   136                          input_event(d->input_dev, EV_KEY, event, 1);
   137                          input_sync(d->input_dev);
   138                          input_event(d->input_dev, EV_KEY, d->last_event, 0);
   139                          input_sync(d->input_dev);
   140                          break;
   141                  default:
   142                          break;
   143          }

regards,
dan carpenter
