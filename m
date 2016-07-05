Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbcGEQma (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 12:42:30 -0400
Date: Tue, 5 Jul 2016 19:42:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] cec-funcs.h: static inlines to pack/unpack CEC
 messages
Message-ID: <20160705164219.GA12369@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 50f7d5a65e5a: "[media] cec-funcs.h: static inlines to
pack/unpack CEC messages" from Jun 17, 2016, leads to the following
static checker warning:

	include/linux/cec-funcs.h:1154 cec_ops_set_osd_string()
	warn: setting length 'msg->len - 3' to negative one

include/linux/cec-funcs.h
  1150  static inline void cec_ops_set_osd_string(const struct cec_msg *msg,
  1151                                            __u8 *disp_ctl,
  1152                                            char *osd)
  1153  {
  1154          unsigned int len = msg->len - 3;

The reason for this warning is that we know msg->len is at least 2 but
this code assumes it is at least 3.  There is a check in
cec_received_msg() which ensures that it is not <= 1.

  1155  
  1156          *disp_ctl = msg->msg[2];
  1157          if (len > 13)
  1158                  len = 13;
  1159          memcpy(osd, msg->msg + 3, len);
  1160          osd[len] = '\0';
  1161  }

regards,
dan carpenter
