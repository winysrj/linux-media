Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35286 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbbJMWVj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 18:21:39 -0400
Received: by iofl186 with SMTP id l186so37150041iof.2
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2015 15:21:39 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Oct 2015 17:21:39 -0500
Message-ID: <CAFZT-jJ0bhiJa743rv_WCB12i5c6UrcoF9=rnvXXpb9Ga7zoQg@mail.gmail.com>
Subject: [Possible Bug] ddbridge: Do not release the acquired lock if
 dvb_attach fails
From: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Christopher Reimer <linux@creimer.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Source file correspondence on the master branch:
https://github.com/torvalds/linux/blob/master/drivers/media/pci/ddbridge/ddbridge-core.c#L595

Summary:
The lock acquired on (port->i2c_gate_lock) is never released if
function (tuner_attach_tda18271) returns on line 605.

Details:
Function tuner_attach_tda18271 (line 595) acquires a lock on
port->i2c_gate_lock via the call to the function pointer
(input->fe->ops.i2c_gate_ctrl(input->fe, 1)) (line 601) which calls
function (drxk_gate_ctrl). However, when the call to function
(dvb_attach) on line 602 fails (returns NULL), the lock on
(port->i2c_gate_lock) is never released.

Thanks,
~Ahmed
