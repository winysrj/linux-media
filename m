Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55362 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab3ABUBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jan 2013 15:01:24 -0500
Message-ID: <50E48D35.4000301@iki.fi>
Date: Wed, 02 Jan 2013 21:40:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/6] em28xx: refactor the code in em28xx_usb_disconnect()
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com> <1356649368-5426-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1356649368-5426-3-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/28/2012 01:02 AM, Frank Schäfer wrote:
> The main purpose of this patch is to move the call of em28xx_release_resources()
> after the call of em28xx_close_extension().
> This is necessary, because some resources might be needed/used by the extensions
> fini() functions when they get closed.
> Also mark the device as disconnected earlier in this function and unify the
> em28xx_uninit_usb_xfer() calls for analog and digital mode.

This looks like it could fix that one bug I reported earlier. Care to 
look these:

em28xx releases I2C adapter earlier than demod/tuner/sec
http://www.spinics.net/lists/linux-media/msg54693.html

em28xx #0: submit of audio urb failed
http://www.spinics.net/lists/linux-media/msg54694.html


regards
Antti

-- 
http://palosaari.fi/
