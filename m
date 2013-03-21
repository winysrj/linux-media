Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33267 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3CUCEm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Mar 2013 22:04:42 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UIUsK-0000F5-Hx
	for linux-media@vger.kernel.org; Thu, 21 Mar 2013 03:05:04 +0100
Received: from 216.239.45.93 ([216.239.45.93])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 03:05:04 +0100
Received: from sheu by 216.239.45.93 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 03:05:04 +0100
To: linux-media@vger.kernel.org
From: John Sheu <sheu@google.com>
Subject: NACK: [PATCH] [media] s5p-mfc: Modify encoder buffer alloc sequence
Date: Thu, 21 Mar 2013 02:00:31 +0000 (UTC)
Message-ID: <loom.20130321T025536-528@post.gmane.org>
References: <1363329876-9021-1-git-send-email-arun.kk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Arun Kumar K <arun.kk <at> samsung.com> writes:

> MFC v6 needs minimum number of capture buffers to be queued
> for encoder depending on the stream type and profile.
> For achieving this the sequence for allocating buffers at
> the encoder is modified similar to that of decoder.
> The new sequence is as follows:
> 
> 1) Set format on CAPTURE plane
> 2) REQBUF on CAPTURE
> 3) QBUFS and STREAMON on CAPTURE
> 4) G_CTRL to get minimum buffers for OUTPUT plane
> 5) REQBUF on OUTPUT with the minimum buffers given by driver

NACK: the commit summary mentions the CAPTURE queue, but we're actually changing 
the OUTPUT queue allocation sequence.  Please fix.

