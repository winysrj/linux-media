Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44388
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933006AbcKPOjm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 09:39:42 -0500
Subject: Re: [PATCH v4 0/3] Media Device Allocator API
To: mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        laurent.pinchart@ideasonboard.com
References: <cover.1479271294.git.shuahkh@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <fd9a20bd-fdbf-bb62-ba5f-1605a5293b28@osg.samsung.com>
Date: Wed, 16 Nov 2016 07:39:29 -0700
MIME-Version: 1.0
In-Reply-To: <cover.1479271294.git.shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the duplicates. Replying to catch bounced emails on the original
patch emails from git send-email

On 11/16/2016 07:29 AM, Shuah Khan wrote:
> Media Device Allocator API to allows multiple drivers share a media device.
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.
> 
> Patches 0001 and 0002 are rebased to 4.9-rc4. Patch 0003 for snd-usb-audio
> is a rebase of the patch that was tested with the original Media Device
> Allocator patch series.
> 
> snd-usb-audio patch includes the fixes found during 4.7-rc1 time in the
> original snd-usb-audio patch.
> 
> Changes to patch 0001 since v3:
> - Fixed undefined reference to `__media_device_usb_init compile error when
>   CONFIG_USB is disabled.
> - Fixed kernel paging error when accessing /dev/mediaX after rmmod of the
>   module that owns the media_device. The fix bumps the reference count for
>   the owner when second driver comes along to share the media_device. If
>   au0828 owns the media_device, then snd_usb_audio will bump the refcount
>   for au0828, so it won't get deleted and vice versa.
> 
> Changes to patch 0002 since v2:
> - Updated media_device_delete() to pass in module name.
> 
> Changes to patch 0003 since the last version in 4.7-rc1:
> - Included fixes to bugs found during testing. 
> - Updated to use the Media Allocator API.
> 
> This patch series has been tested with au0828 and snd-usb-audio drivers.
> Ran bind and unbind loop tests on each driver with mc_nextgen_test and
> media_device_test app loop tests while checking lsmod and dmesg.
> 
> Please refer to tools/testing/selftests/media_tests/regression_test.txt
> for testing done on this series.
> 
> Shuah Khan (3):
>   media: Media Device Allocator API
>   media: change au0828 to use Media Device Allocator API
>   sound/usb: Use Media Controller API to share media resources
> 
>  drivers/media/Makefile                 |   3 +-
>  drivers/media/media-dev-allocator.c    | 146 +++++++++++++++
>  drivers/media/usb/au0828/au0828-core.c |  12 +-
>  drivers/media/usb/au0828/au0828.h      |   1 +
>  include/media/media-dev-allocator.h    |  87 +++++++++
>  sound/usb/Kconfig                      |   4 +
>  sound/usb/Makefile                     |   2 +
>  sound/usb/card.c                       |  14 ++
>  sound/usb/card.h                       |   3 +
>  sound/usb/media.c                      | 314 +++++++++++++++++++++++++++++++++
>  sound/usb/media.h                      |  73 ++++++++
>  sound/usb/mixer.h                      |   3 +
>  sound/usb/pcm.c                        |  28 ++-
>  sound/usb/quirks-table.h               |   1 +
>  sound/usb/stream.c                     |   2 +
>  sound/usb/usbaudio.h                   |   6 +
>  16 files changed, 685 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/media/media-dev-allocator.c
>  create mode 100644 include/media/media-dev-allocator.h
>  create mode 100644 sound/usb/media.c
>  create mode 100644 sound/usb/media.h
> 

