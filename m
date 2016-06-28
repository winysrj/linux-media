Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47945 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbcF1T5x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:57:53 -0400
Subject: Re: [PATCH v2 0/2] Media Device Allocator API
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	inki.dae@samsung.com, g.liakhovetski@gmx.de
References: <cover.1464132578.git.shuahkh@osg.samsung.com>
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5772D686.30902@osg.samsung.com>
Date: Tue, 28 Jun 2016 13:56:54 -0600
MIME-Version: 1.0
In-Reply-To: <cover.1464132578.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2016 05:39 PM, Shuah Khan wrote:
> Media Device Allocator API to allows multiple drivers share a media device.
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.
> 
> This patch series has been tested with au0828 and snd-usb-audio drivers.
> snd-us-audio patch isn't included in this series. Once this patch series
> is reviews and gets a stable state, I will send out the snd-usb-audio
> patch.
> 
> Changes since Patch v1 series: (based on Hans Virkuil's review)
> - Removed media_device_get() and media_device_allocate(). These are
>   unnecessary.
> - media_device_usb_allocate() holds media_device_lock to do allocate
>   and initialize the media device.
> - Changed media_device_put() to media_device_delete() for symmetry with
>   media_device_*_allocate().
> - Dropped media_device_unregister_put(). au0828 calls media_device_delete()
>   instead.
> 
> Shuah Khan (2):
>   media: Media Device Allocator API
>   media: change au0828 to use Media Device Allocator API
> 
>  drivers/media/Makefile                 |   3 +-
>  drivers/media/media-dev-allocator.c    | 120 +++++++++++++++++++++++++++++++++
>  drivers/media/usb/au0828/au0828-core.c |  12 ++--
>  drivers/media/usb/au0828/au0828.h      |   1 +
>  include/media/media-dev-allocator.h    |  85 +++++++++++++++++++++++
>  5 files changed, 212 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/media/media-dev-allocator.c
>  create mode 100644 include/media/media-dev-allocator.h
> 


Hi Mauro,

Are you planning to get this inot 4,8-rc1? 

The first patch is now at [PATCH v3] media: Media Device Allocator API
that has been reviewed by Hans.

https://lkml.org/lkml/2016/5/27/530

thanks,
-- Shuah
