Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sg1on0148.outbound.protection.outlook.com ([134.170.132.148]:62705
	"EHLO APAC01-SG1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751122AbaITJIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 05:08:11 -0400
From: James Harper <james@ejbdigital.com.au>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH 1/3] vb2: fix VBI/poll regression
Date: Sat, 20 Sep 2014 09:08:05 +0000
Message-ID: <fc1bd2008429476abaf3e3fab719fe52@SIXPR04MB304.apcprd04.prod.outlook.com>
References: <1411203375-15310-1-git-send-email-hverkuil@xs4all.nl>
 <1411203375-15310-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1411203375-15310-2-git-send-email-hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> The recent conversion of saa7134 to vb2 unconvered a poll() bug that
> broke the teletext applications alevt and mtt. These applications
> expect that calling poll() without having called VIDIOC_STREAMON will
> cause poll() to return POLLERR. That did not happen in vb2.
> 
> This patch fixes that behavior. It also fixes what should happen when
> poll() is called when STREAMON is called but no buffers have been
> queued. In that case poll() will also return POLLERR, but only for
> capture queues since output queues will always return POLLOUT
> anyway in that situation.
> 
> This brings the vb2 behavior in line with the old videobuf behavior.
> 

What (mis)behaviour would this cause in userspace application?

Thanks

James
