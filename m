Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30567 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab3LDONT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 09:13:19 -0500
Date: Wed, 4 Dec 2013 17:12:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joerg Heckenbach <joerg@heckenbach-aw.de>,
	Dwaine Garden <DwaineGarden@rogers.com>
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (4922): Add usbvision driver
Message-ID: <20131204141257.GB11681@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Joerg and Dwaine,

The patch 781aa1d1ab7b: "V4L/DVB (4922): Add usbvision driver" from
Dec 4, 2006, leads to the following
static checker warning:
"drivers/media/usb/usbvision/usbvision-core.c:298 scratch_get()
	 error: memcpy() 'data' too small (400 vs 401)"

drivers/media/usb/usbvision/usbvision-core.c
   751          strip_len = 2 * (unsigned int)strip_header[1];
   752          if (strip_len > USBVISION_STRIP_LEN_MAX) {
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If we overrun here...

   753                  /* strip overrun */
   754                  /* I think this never happens */
   755                  usbvision_request_intra(usbvision);
   756          }
   757  
   758          if (scratch_len(usbvision) < strip_len) {
   759                  /* there is not enough data for the strip */
   760                  return parse_state_out;
   761          }
   762  
   763          if (usbvision->intra_frame_buffer) {
   764                  Y = usbvision->intra_frame_buffer + frame->frmwidth * frame->curline;
   765                  U = usbvision->intra_frame_buffer + image_size + (frame->frmwidth / 2) * (frame->curline / 2);
   766                  V = usbvision->intra_frame_buffer + image_size / 4 * 5 + (frame->frmwidth / 2) * (frame->curline / 2);
   767          } else {
   768                  return parse_state_next_frame;
   769          }
   770  
   771          clipmask_index = frame->curline * MAX_FRAME_WIDTH;
   772  
   773          scratch_get(usbvision, strip_data, strip_len);
                                       ^^^^^^^^^^^^^^^^^^^^^
Then we scribble on the stack here because "strip_data" only has
USBVISION_STRIP_LEN_MAX bytes.  It is a security problem.

regards,
dan carpenter

