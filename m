Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:45428 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LWNpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 08:45:14 -0500
Received: by mail-ee0-f41.google.com with SMTP id d41so3121756eek.14
        for <linux-media@vger.kernel.org>; Sun, 23 Dec 2012 05:45:12 -0800 (PST)
Message-ID: <50D70AFB.5070702@googlemail.com>
Date: Sun, 23 Dec 2012 14:45:31 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Patch update notification: 37 patches updated
References: <20121223000802.14820.14465@www.linuxtv.org>
In-Reply-To: <20121223000802.14820.14465@www.linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Am 23.12.2012 01:08, schrieb Patchwork:
> Hello,
>
> The following patches (submitted by you) have been updated in patchwork:
>
>  * [3/6] em28xx: fix capture type setting in em28xx_urb_data_copy_vbi()
>      - http://patchwork.linuxtv.org/patch/15651/
>     was: New
>     now: Accepted
>
>  * [8/9] em28xx: move the em2710/em2750/em28xx specific frame data processing code to a separate function
>      - http://patchwork.linuxtv.org/patch/15798/
>     was: New
>     now: Accepted
>
>  * [4/6] em28xx: fix/improve frame field handling in em28xx_urb_data_copy_vbi()
>      - http://patchwork.linuxtv.org/patch/15652/
>     was: New
>     now: Accepted

This patch has not been applied yet to the media-tree.
Without this patch, frame data processing for non-interlaced devices is
broken.

Regards,
Frank

>  * [v2,18/21] em28xx: add fields for analog and DVB USB transfer type selection to struct em28xx
>      - http://patchwork.linuxtv.org/patch/15400/
>     was: New
>     now: Accepted
>
>  * [v2,07/21] em28xx: update description of em28xx_irq_callback
>      - http://patchwork.linuxtv.org/patch/15389/
>     was: New
>     now: Accepted
>
>  * [v2,15/21] em28xx: rename function em28xx_dvb_isoc_copy and extend for USB bulk transfers
>      - http://patchwork.linuxtv.org/patch/15397/
>     was: New
>     now: Accepted
>
>  * [v2,11/21] em28xx: clear USB halt/stall condition in em28xx_init_usb_xfer when using bulk transfers
>      - http://patchwork.linuxtv.org/patch/15393/
>     was: New
>     now: Accepted
>
>  * [7/9] em28xx: em28xx_urb_data_copy(): move duplicate code for capture_type=0 and capture_type=2 to a function
>      - http://patchwork.linuxtv.org/patch/15797/
>     was: New
>     now: Accepted
>
>  * [v2,05/21] em28xx: rename struct em28xx_usb_isoc_ctl to em28xx_usb_ctl
>      - http://patchwork.linuxtv.org/patch/15387/
>     was: New
>     now: Accepted
>
>  * [v2,19/21] em28xx: set USB alternate settings for analog video bulk transfers properly
>      - http://patchwork.linuxtv.org/patch/15401/
>     was: New
>     now: Accepted
>
>  * [v2,08/21] em28xx: rename function em28xx_uninit_isoc to em28xx_uninit_usb_xfer
>      - http://patchwork.linuxtv.org/patch/15390/
>     was: New
>     now: Accepted
>
>  * [1/6] em28xx: fix video data start position calculation in em28xx_urb_data_copy_vbi()
>      - http://patchwork.linuxtv.org/patch/15649/
>     was: New
>     now: Accepted
>
>  * [v2,10/21] em28xx: create a common function for isoc and bulk USB transfer initialization
>      - http://patchwork.linuxtv.org/patch/15392/
>     was: New
>     now: Accepted
>
>  * [6/9] em28xx: move caching of pointer to vmalloc memory in videobuf to struct em28xx_buffer
>      - http://patchwork.linuxtv.org/patch/15796/
>     was: New
>     now: Accepted
>
>  * [2/6] em28xx: make sure the packet size is >= 4 before checking for headers in em28xx_urb_data_copy_vbi()
>      - http://patchwork.linuxtv.org/patch/15650/
>     was: New
>     now: Accepted
>
>  * [1/9] em28xx: refactor get_next_buf() and use it for vbi data, too
>      - http://patchwork.linuxtv.org/patch/15793/
>     was: New
>     now: Accepted
>
>  * [v2,09/21] em28xx: create a common function for isoc and bulk URB allocation and setup
>      - http://patchwork.linuxtv.org/patch/15391/
>     was: New
>     now: Accepted
>
>  * [v2,21/21] em28xx: add module parameter for selection of the preferred USB transfer type
>      - http://patchwork.linuxtv.org/patch/15403/
>     was: New
>     now: Accepted
>
>  * [v2,04/21] em28xx: rename struct em28xx_usb_isoc_bufs to em28xx_usb_bufs
>      - http://patchwork.linuxtv.org/patch/15386/
>     was: New
>     now: Accepted
>
>  * [5/9] em28xx: refactor VBI data processing code in em28xx_urb_data_copy()
>      - http://patchwork.linuxtv.org/patch/15795/
>     was: New
>     now: Accepted
>
>  * [3/9] em28xx: remove obsolete field 'frame' from struct em28xx_buffer
>      - http://patchwork.linuxtv.org/patch/15794/
>     was: New
>     now: Accepted
>
>  * [6/6] em28xx: use common urb data copying function for vbi and non-vbi data streams
>      - http://patchwork.linuxtv.org/patch/15654/
>     was: New
>     now: Accepted
>
>  * [v2,20/21] em28xx: improve USB endpoint logic, also use bulk transfers
>      - http://patchwork.linuxtv.org/patch/15402/
>     was: New
>     now: Accepted
>
>  * [v2,02/21] em28xx: clarify meaning of field 'progressive' in struct em28xx
>      - http://patchwork.linuxtv.org/patch/15384/
>     was: New
>     now: Accepted
>
>  * [4/9] em28xx: move field 'pos' from struct em28xx_dmaqueue to struct em28xx_buffer
>      - http://patchwork.linuxtv.org/patch/15801/
>     was: New
>     now: Accepted
>
>  * [2/9] em28xx: use common function for video and vbi buffer completion
>      - http://patchwork.linuxtv.org/patch/15800/
>     was: New
>     now: Accepted
>
>  * [v2,1/5] em28xx: clean up the data type mess of the i2c transfer function parameters
>      - http://patchwork.linuxtv.org/patch/15914/
>     was: New
>     now: Accepted
>
>  * [v2,03/21] em28xx: rename isoc packet number constants and parameters
>      - http://patchwork.linuxtv.org/patch/15385/
>     was: New
>     now: Accepted
>
>  * [v2,14/21] em28xx: rename function em28xx_isoc_copy_vbi and extend for USB bulk transfers
>      - http://patchwork.linuxtv.org/patch/15396/
>     was: New
>     now: Accepted
>
>  * [5/6] em28xx: em28xx_urb_data_copy_vbi(): calculate vbi_size only if needed
>      - http://patchwork.linuxtv.org/patch/15653/
>     was: New
>     now: Accepted
>
>  * [v2,17/21] em28xx: rename some USB parameter fields in struct em28xx to clarify their role
>      - http://patchwork.linuxtv.org/patch/15399/
>     was: New
>     now: Accepted
>
>  * [v2,12/21] em28xx: remove double checks for urb->status == -ENOENT in urb_data_copy functions
>      - http://patchwork.linuxtv.org/patch/15394/
>     was: New
>     now: Accepted
>
>  * [9/9] em28xx: clean up and unify functions em28xx_copy_vbi() em28xx_copy_video()
>      - http://patchwork.linuxtv.org/patch/15799/
>     was: New
>     now: Accepted
>
>  * [v2,01/21] em28xx: fix wrong data offset for non-interlaced mode in em28xx_copy_video
>      - http://patchwork.linuxtv.org/patch/15383/
>     was: New
>     now: Accepted
>
>  * [v2,13/21] em28xx: rename function em28xx_isoc_copy and extend for USB bulk transfers
>      - http://patchwork.linuxtv.org/patch/15395/
>     was: New
>     now: Accepted
>
>  * [v2,06/21] em28xx: remove obsolete #define EM28XX_URB_TIMEOUT
>      - http://patchwork.linuxtv.org/patch/15388/
>     was: New
>     now: Accepted
>
>  * [v2,16/21] em28xx: rename usb debugging module parameter and macro
>      - http://patchwork.linuxtv.org/patch/15398/
>     was: New
>     now: Rejected
>
> This email is a notification only - you do not need to respond.
>
> -
>
> Patches submitted to linux-media@vger.kernel.org have the following
> possible states:
>
> New: Patches not yet reviewed (typically new patches);
>
> Under review: When it is expected that someone is reviewing it (typically,
> 	      the driver's author or maintainer). Unfortunately, patchwork
> 	      doesn't have a field to indicate who is the driver maintainer.
> 	      If in doubt about who is the driver maintainer please check the
> 	      MAINTAINERS file or ask at the ML;
>
> Superseded: when the same patch is sent twice, or a new version of the
> 	    same patch is sent, and the maintainer identified it, the first
> 	    version is marked as such. It is also used when a patch was
> 	    superseeded by a git pull request.
>
> Obsoleted: patch doesn't apply anymore, because the modified code doesn't
> 	   exist anymore.
>
> Changes requested: when someone requests changes at the patch;
>
> Rejected: When the patch is wrong or doesn't apply. Most of the
> 	  time, 'rejected' and 'changes requested' means the same thing
> 	  for the developer: he'll need to re-work on the patch.
>
> RFC: patches marked as such and other patches that are also RFC, but the
>      patch author was not nice enough to mark them as such. That includes:
> 	- patches sent by a driver's maintainer who send patches
> 	  via git pull requests;
> 	- patches with a very active community (typically from developers
> 	  working with embedded devices), where lots of versions are
> 	  needed for the driver maintainer and/or the community to be
> 	  happy with.
>
> Not Applicable: for patches that aren't meant to be applicable via 
> 	        the media-tree.git.
>
> Accepted: when some driver maintainer says that the patch will be applied
> 	  via his tree, or when everything is ok and it got applied
> 	  either at the main tree or via some other tree (fixes tree;
> 	  some other maintainer's tree - when it belongs to other subsystems,
> 	  etc);
>
> If you think any status change is a mistake, please send an email to the ML.
>
> -
>
> This is an automated mail sent by the patchwork system at
> patchwork.linuxtv.org. To stop receiving these notifications, edit
> your mail settings at:
>   http://patchwork.linuxtv.org/mail/

