Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:46808 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab1JRWA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 18:00:59 -0400
Received: from compute5.internal (compute5.nyi.mail.srv.osa [10.202.2.45])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id CAD0720DBE
	for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 18:00:58 -0400 (EDT)
Received: from [10.40.142.32] (pool101.bizrate.com [216.52.235.101])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 7E239483403
	for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 18:00:58 -0400 (EDT)
Message-ID: <4E9DF719.7000609@fastmail.co.uk>
Date: Tue, 18 Oct 2011 15:00:57 -0700
From: Greg Bowyer <gbowyer@fastmail.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: PVR-2200 error with what I think is tuning
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there

You probably get this a lot, with the latest and greatest drivers from 
your git repository at Steve Tosh's website I get the following after a 
few days

[198934.085303] tda18271_write_regs: [4-0060|S] ERROR: idx = 0x5, len = 
1, i2c_transfer returned: -5
[198934.085310] tda18271_init: [4-0060|S] error -5 on line 831
[198934.085317] tda18271_tune: [4-0060|S] error -5 on line 909
[198934.085324] tda18271_set_params: [4-0060|S] error -5 on line 994
[198934.085331] saa7164_cmd_send() No free sequences
[198934.085336] saa7164_api_i2c_read() error, ret(1) = 0xc
[198934.085341] tda10048_readreg: readreg error (ret == -5)


[198934.087195] tda10048_readreg: readreg error (ret == -5)
[198934.087209] saa7164_cmd_send() No free sequences
[198934.087214] saa7164_api_i2c_read() error, ret(1) = 0xc
[198934.087220] tda10048_readreg: readreg error (ret == -5)

My tuning software is tvheadend (which I would prefer to keep)

I started to look at the sourcecode, but I know too little about I2C to 
make any sense of what might be bugging out

Is there anything I can do to avoid this ?

-- Greg
