Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:54770 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552AbZFBGsi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2009 02:48:38 -0400
Received: by mail-bw0-f222.google.com with SMTP id 22so7920008bwz.37
        for <linux-media@vger.kernel.org>; Mon, 01 Jun 2009 23:48:40 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 2 Jun 2009 09:48:40 +0300
Message-ID: <eaf6cbc30906012348h73a96d51mc1b5f4eb538dc93@mail.gmail.com>
Subject: SmarDTV/Nagra CAM does not initialise
From: Tomer Barletz <barletz@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
When inserting SmarDTV/Nagra CAM, I get the following error:
cimax_poll_slot_status: change CAM state CIMAX0 Slot0 module_present = 1
state = 0
cimax_slot_reset: CIMAX0 slot0 READY!
dvb_ca adapter 0: Invalid PC card inserted  :(

It seems that this CAM does not support the usual init tuples (0x1D, 0x1C...).
I've changed the code so that all the tuples are printed to the
screen, ignoring the default tuples. This is how it looks (tuple data
excluded):

TUPLE type:0x8a length:174
TUPLE type:0x47 length:45
TUPLE type:0x25 length:133
TUPLE type:0x9f length:38
TUPLE type:0xc9 length:102
TUPLE type:0x6a length:24
TUPLE type:0xdc length:138
TUPLE type:0x38 length:251
TUPLE type:0xc length:100
TUPLE type:0x0 length:138
TUPLE type:0x27 length:52
TUPLE type:0x70 length:24
TUPLE type:0x1f length:156
TUPLE type:0x1 length:236
TUPLE type:0x54 length:0
TUPLE type:0xc1 length:14
TUPLE type:0x14 length:0
END OF CHAIN TUPLE type:0xff

Is that means that dvb-core does not support Nagra CAMs?

Any help or others experience is greatly appreciated,
Tomer
