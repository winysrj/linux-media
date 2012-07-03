Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:49682 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2GCHoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 03:44:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/4] drxk: use request_firmware_nowait()
Date: Tue, 3 Jul 2012 09:43:58 +0200
References: <20120629124719.2cf23f6b@endymion.delvare> <1341006717-32373-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1341006717-32373-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207030943.58833.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro!

On Fri 29 June 2012 23:51:53 Mauro Carvalho Chehab wrote:
> This patch series should be applied after "i2c: Export an unlocked 
> flavor of i2c_transfer". It converts the drxk driver to use
> request_firmware_nowait() and prevents I2C bus usage during firmware
> load.

Can you take a look at media_build? After this change it fails to build drxk
for kernels <= 3.4 (i.e., all kernels :-) ).

Regards,

	Hans

> 
> If firmware load doesn't happen and the device cannot be reset due
> to that, -ENODEV will be returned to all dvb callbacks.
> 
> Mauro Carvalho Chehab (4):
>   [media] drxk: change it to use request_firmware_nowait()
>   [media] drxk: pass drxk priv struct instead of I2C adapter to i2c
>     calls
>   [media] drxk: Lock I2C bus during firmware load
>   [media] drxk: prevent doing something wrong when init is not ok
> 
>  drivers/media/dvb/frontends/drxk_hard.c |  228 +++++++++++++++++++++++--------
>  drivers/media/dvb/frontends/drxk_hard.h |   16 ++-
>  2 files changed, 187 insertions(+), 57 deletions(-)
> 
> 
