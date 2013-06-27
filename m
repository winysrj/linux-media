Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-auth.no-ip.com ([8.23.224.61]:17217 "EHLO
	out.smtp-auth.no-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751629Ab3F0SqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 14:46:01 -0400
Received: from win7 (unknown [76.185.67.32])
	(Authenticated sender: blueflowamericas.com@noip-smtp)
	by smtp-auth.no-ip.com (Postfix) with ESMTPA id 35EAC40050A
	for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 11:39:10 -0700 (PDT)
From: "Carl-Fredrik Sundstrom" <cf@blueflowamericas.com>
To: <linux-media@vger.kernel.org>
Subject: lgdt3304
Date: Thu, 27 Jun 2013 13:38:50 -0500
Message-ID: <010c01ce7365$9181ff30$b485fd90$@blueflowamericas.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Has the driver for lgdt3304 been tested ? I am trying to get a new card
working 

AVerMedia AVerTVHD Duet PCTV tuner (A188) A188-AF PCI-Express x1 Interface

It is using

1 x saa7160E
2 x LGDT3304
2 x TDA18271HD/C2

I get so far that I can load a basic driver by modifying the existing
saa716x driver, I can detect the TDA18271HD/C2, but I fail to detect the
LGDT3304 when attaching it using the 3305 driver.

I always fail at the first read from LGDT3305_GEN_CTRL_2, does this register
even exist in lgdt3304 or is it specific to lgdt3305?

        /* verify that we're talking to a lg dt3304/5 */
         ret = lgdt3305_read_reg(state, LGDT3305_GEN_CTRL_2, &val); 
         if ((lg_fail(ret)) | (val == 0))
        {
                printk("fail 1\n");
                goto fail;
        }

Since I do find the TDA18271HD/C2 I don't think there is something wrong
with the i2c buss. I also tried every possible i2c address without success.
The lgdt3305 has option between address 0x0e and 0x59, is it the same for
3304 ?

This is the first time I am trying to get a driver to work in Linux. Please
help me.

Thanks /// Carl-Fredrik

