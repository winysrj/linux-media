Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50566 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeAWKuv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 05:50:51 -0500
Date: Tue, 23 Jan 2018 13:50:33 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: stoth@hauppauge.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] V4L/DVB(7872): mxl5005s: checkpatch.pl compliance
Message-ID: <20180123105033.GA13590@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Steven Toth,

The patch d211017b9544: "V4L/DVB(7872): mxl5005s: checkpatch.pl
compliance" from May 1, 2008, leads to the following static checker
warning:

	drivers/media/tuners/mxl5005s.c:1817 MXL_BlockInit()
	warn: both sides of ternary the same: '1'

drivers/media/tuners/mxl5005s.c
  1812          }
  1813  
  1814          /* Charge Pump Control Dig  Ana */
  1815          status += MXL_ControlWrite(fe, RFSYN_CHP_GAIN, state->Mode ? 5 : 8);
  1816          status += MXL_ControlWrite(fe,
  1817                  RFSYN_EN_CHP_HIGAIN, state->Mode ? 1 : 1);
                                             ^^^^^^^^^^^^^^^^^^^
  1818          status += MXL_ControlWrite(fe, EN_CHP_LIN_B, state->Mode ? 0 : 0);
                                                             ^^^^^^^^^^^^^^^^^^^
What do these mean?  What are they supposed to do?

  1819  

regards,
dan carpenter
