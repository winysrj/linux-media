Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50638 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbcB0KwM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:52:12 -0500
Date: Sat, 27 Feb 2016 13:52:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org
Subject: re: V4L/DVB (3692): Keep experimental SLICED_VBI defines under an
 #if 0
Message-ID: <20160227105204.GE14086@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 9bc7400a9d01: "V4L/DVB (3692): Keep experimental SLICED_VBI
defines under an #if 0" from Mar 29, 2006, leads to the following
static checker warning:

	drivers/media/i2c/tvp5150.c:719 tvp5150_get_vbi()
	error: buffer overflow regs 5 <= 14

drivers/media/i2c/tvp5150.c
   716                  }
   717                  pos = ret & 0x0f;
   718                  if (pos < 0x0f)
   719                          type |= regs[pos].type.vbi_type;

It used to be that regs[] had 0x10 elements (or 0xf if you don't count
the empty element at the end), but we ifdef zero most of them so now
we're reading beyond the end of the array.

   720          }
   721  

regards,
dan carpenter
