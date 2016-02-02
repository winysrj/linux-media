Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:32812 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbcBBQFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Feb 2016 11:05:07 -0500
Received: by mail-io0-f174.google.com with SMTP id f81so22167434iof.0
        for <linux-media@vger.kernel.org>; Tue, 02 Feb 2016 08:05:07 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 2 Feb 2016 17:05:06 +0100
Message-ID: <CAJfOKByVva72g_1kJyMKGFHr2Jz+Yo6BgZPp_EENj9m4vXOHBA@mail.gmail.com>
Subject: Use xilinx video drivers in PCIe device
From: Franck Jullien <franck.jullien@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I need to use a Xilinx video infrastructure on a PCIe board.
As far as I understand it, all Xilinx video drivers make use of the
device-tree for configuration.
However, my idea is to create a MFD device to bind video drivers. That
would require Xilinx video drivers to check platform_data and continue
with device tree configuration if it is null or use platform data if
available.

Do you think such a change in Xilinx drivers can be considered
upstream ? Is this the way to go ?

Thanks in advance,

Franck.
