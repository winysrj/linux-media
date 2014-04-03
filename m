Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52621 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaDCXOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 19:14:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Scheuermann, Mail" <Scheuermann@barco.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: v4l2_buffer with PBO mapped memory
Date: Fri, 04 Apr 2014 01:16:45 +0200
Message-ID: <82154683.DEhQIaoLxb@avalon>
In-Reply-To: <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2C949@KUUMEX11.barco.com>
References: <533C2872.5090603@barco.com> <11263729.kS3FzW2BUL@avalon> <67C778DDEF97AE4BA9DC4BA8ECFD811E1DB2C949@KUUMEX11.barco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On Thursday 03 April 2014 16:52:19 Scheuermann, Mail wrote:
> Hi Laurent,
> 
> the driver my device uses is the uvcvideo. I have the kernel 3.11.0-18 from
> Ubuntu 13.10 running. It is built in in a Thinkpad X240 notebook.

OK. A bit of debugging will then be needed. Could you set the videobuf2-core 
debug parameter to 3, retry your test case and send us the kernel log ?

-- 
Regards,

Laurent Pinchart

