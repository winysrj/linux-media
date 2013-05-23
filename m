Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:61018 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab3EWIv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 04:51:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 0/6] media: i2c: ths7303 feature enhancement and cleanup
Date: Thu, 23 May 2013 10:51:40 +0200
Cc: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305231051.40961.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 15 May 2013 13:57:16 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> This patch series enables the ths7303 driver for asynchronous probing, OF
> support with some cleanup patches.
> 
> Lad, Prabhakar (6):
>   media: i2c: ths7303: remove init_enable option from pdata
>   ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
>   media: i2c: ths7303: remove unnecessary function ths7303_setup()
>   media: i2c: ths7303: make the pdata as a constant pointer
>   media: i2c: ths7303: add support for asynchronous probing
>   media: i2c: ths7303: add OF support

Can you post this again in the right order (swapping the first two patches)
and preferably with an ack from the mach-davinci maintainer?

Once I have that I can take in the first four patches and I can take the
final two patches once the async support is merged.

Regards,

	Hans
