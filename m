Return-path: <linux-media-owner@vger.kernel.org>
Received: from kripserver.net ([91.143.80.239]:40532 "EHLO mail.kripserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbbAAN30 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jan 2015 08:29:26 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.kripserver.net (Postfix) with ESMTP id 9E8843AE0C6
	for <linux-media@vger.kernel.org>; Thu,  1 Jan 2015 13:20:45 +0000 (UTC)
Received: from mail.kripserver.net ([91.143.80.239])
	by localhost (mail.kripserver.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id EXkIUxWFTEPS for <linux-media@vger.kernel.org>;
	Thu,  1 Jan 2015 13:20:44 +0000 (UTC)
Received: from [192.168.189.220] (unknown [185.5.29.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kripserver.net (Postfix) with ESMTPSA id 3B1B33AE096
	for <linux-media@vger.kernel.org>; Thu,  1 Jan 2015 13:20:44 +0000 (UTC)
Message-ID: <54A549AA.4070700@kripserver.net>
Date: Thu, 01 Jan 2015 14:20:42 +0100
From: Jannis <jannis-lists@kripserver.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: How to access DVB-onboard RC? (Technisat)
References: <54A2A1A9.9090008@gmx.net>
In-Reply-To: <54A2A1A9.9090008@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.12.2014 um 13:59 schrieb JPT:
> I currently try to make my Technisat IR-RC work.
> But nothing happens when I press a key.
> What's wrong?

It depends on what you expect to happen when you press a key on the
remote control. The kernel's and driver's job is primarily to deliver
the events to the userspace where they can be handled by a tool or a daemon.

> triggerhappy config:

Never heared of a software with such a name.

> Registered IR keymap rc-technisat-usb2
> input: IR-receiver inside an USB DVB receiver as
> /devices/soc/soc:pcie-controller/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/rc/rc0/input1
> evbug: Connected device: input1 (IR-receiver inside an USB DVB receiver
> at usb-0000:01:00.0-1/ir0)
> rc0: IR-receiver inside an USB DVB receiver as
> /devices/soc/soc:pcie-controller/pci0000:00/0000:00:01.0/0000:01:00.0/usb1/1-1/rc/rc0

As you can see, the input event devices are created and you should find
the device nodes somewhere at /dev/input/... You can try to use cat on
them and see if something happens when you press a button on the remote
control.

> do I need lirc?

Again, depends on what you want to happen on a key-press.

	Jannis

