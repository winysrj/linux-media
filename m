Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36502 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbcDUKQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 06:16:43 -0400
Date: Thu, 21 Apr 2016 13:15:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Isely <isely@isely.net>
Cc: linux-media@vger.kernel.org
Subject: re: file (standard input) matches
Message-ID: <20160421101556.GA7699@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello file (standard input) matches,

The patch d855497edbfb: "V4L/DVB (4228a): pvrusb2 to kernel 2.6.18" from
Jun 26 2006, leads to the following static checker warning:

	drivers/media/usb/pvrusb2/pvrusb2-hdw.c:881 ctrl_std_sym_to_val()
	error: uninitialized symbol 'id'.

drivers/media/usb/pvrusb2/pvrusb2-hdw.c
   873  static int ctrl_std_sym_to_val(struct pvr2_ctrl *cptr,
   874                                 const char *bufPtr,unsigned int bufSize,
   875                                 int *mskp,int *valp)
   876  {
   877          int ret;
   878          v4l2_std_id id;
   879          ret = pvr2_std_str_to_id(&id,bufPtr,bufSize);
   880          if (ret < 0) return ret;

pvr2_std_str_to_id() appears to return 0 on error and !0 on success.
Not joking, that's the actual code.

   881          if (mskp) *mskp = id;
   882          if (valp) *valp = id;
   883          return 0;
   884  }

regards,
dan carpenter
