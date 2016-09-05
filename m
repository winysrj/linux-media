Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44473 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934293AbcIEUTi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 16:19:38 -0400
Date: Mon, 5 Sep 2016 23:19:35 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Oliver Collyer <ovcollyer@mac.com>
Cc: linux-media@vger.kernel.org
Subject: Re: uvcvideo error on second capture from USB device, leading to
 V4L2_BUF_FLAG_ERROR
Message-ID: <20160905201935.wpgtrtt7e4bjjylo@zver>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
 <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AE433005-988F-4352-8CF3-30690C82CAA6@mac.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 05, 2016 at 10:43:49PM +0300, Oliver Collyer wrote:
> I do not have any knowledge of uvcvideo and the associated classes apart from the studying I’ve done the past day or two, but it seems likely that error -71 and the later setting of V4L2_BUF_FLAG_ERROR are linked. Also, the fact it only happens in captures after the first one suggests something isn’t being cleared down or released properly in uvcvideo/v4l2-core at the end of the first capture.
> 
> Let me know what I need to do next to further narrow it down.

Have tried to reproduce this (with kernel 4.6.0 and fresh build of
ffmpeg) with uvcvideo-driven laptop webcam, and it doesn't happen to me.
Also -EPROTO in uvcvideo comes from low-level USB stuff, see
drivers/media/usb/uvc/uvc_status.c:127:

	case -EPROTO:		/* Device is disconnected (reported by some
				 * host controller). */

So it seems like hardware misbehaves. To further clairify situation, I
have such question: do the devices work in other operation systems on
the same machine?

Reviewing your original email mentioning that two different devices
reproduce same problem, which is apparently related to disconnection in
the middle of USB communication, I came to me that the connected device
may be underpowered. So,
 - try plugging your devices through reliable _active_ USB hub,
 - use the most reliable cables you can get,
 - plug into USB 3.0 port if available - it should provide more power
   than 1.0 and 2.0.
