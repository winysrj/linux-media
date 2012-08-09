Return-path: <linux-media-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:11853 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932262Ab2HIMzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 08:55:16 -0400
Received: from mail260-tx2 (localhost [127.0.0.1])	by
 mail260-tx2-R.bigfish.com (Postfix) with ESMTP id D822B1F00116	for
 <linux-media@vger.kernel.org>; Thu,  9 Aug 2012 12:55:14 +0000 (UTC)
Received: from TX2EHSMHS040.bigfish.com (unknown [10.9.14.254])	by
 mail260-tx2.bigfish.com (Postfix) with ESMTP id 1A73A19C0046	for
 <linux-media@vger.kernel.org>; Thu,  9 Aug 2012 12:55:12 +0000 (UTC)
Received: from b20223-02.ap.freescale.net (b20223-02.ap.freescale.net
 [10.192.242.124])	by az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id
 q79Ct9HF014524	for <linux-media@vger.kernel.org>; Thu, 9 Aug 2012 05:55:10
 -0700
Date: Thu, 9 Aug 2012 20:55:02 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-media@vger.kernel.org>
Subject: __video_register_device: warning cannot be reached if
 warn_if_nr_in_use
Message-ID: <20120809125501.GD3824@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In file drivers/media/video/v4l2-dev.c

int __video_register_device(struct video_device *vdev, int type, int nr,
		int warn_if_nr_in_use, struct module *owner)
{
[...]
	vdev->minor = i + minor_offset;
878:	vdev->num = nr;

vdev->num is set to nr here. 
[...]
	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
		printk(KERN_WARNING "%s: requested %s%d, got %s\n", __func__,
			name_base, nr, video_device_node_name(vdev));

so nr != vdev->num is always false. The warning can never be printed.

Thanks
Richard

