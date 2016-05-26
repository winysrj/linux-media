Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39999 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbcEZOII (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2016 10:08:08 -0400
Date: Thu, 26 May 2016 16:59:54 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: kernel-mentors@selenic.com, devel@driverdev.osuosl.org,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: andrey.utkin@corp.bluecherry.net
Subject: How should I use kernel-defined i2c structs in this driver
Message-ID: <20160526135953.GA20697@zver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could anybody please give a hint - which kernel-defined i2c objects, and how
many of them, I need to define and use to substitute these driver-defined
functions i2c_read(), i2c_write() ?
https://github.com/bluecherrydvr/linux/blob/release/tw5864/1.16/drivers/media/pci/tw5864/tw5864-config.c
In a word, there's 4 chips with different addresses, to which this code
communicates via main chip's dedicated registers.
Do i need a single i2c_adapter or several?
Do i need i2c_client entities?
where should I put what is named "devid" here?

Thanks in advance.
