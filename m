Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:60914 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3ABVSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 16:18:04 -0500
Received: by mail-ea0-f177.google.com with SMTP id c10so5861956eaa.36
        for <linux-media@vger.kernel.org>; Wed, 02 Jan 2013 13:18:02 -0800 (PST)
Message-ID: <50E4A423.4090804@googlemail.com>
Date: Wed, 02 Jan 2013 22:18:27 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/6] em28xx: refactor the code in em28xx_usb_disconnect()
References: <1356649368-5426-1-git-send-email-fschaefer.oss@googlemail.com> <1356649368-5426-3-git-send-email-fschaefer.oss@googlemail.com> <50E48D35.4000301@iki.fi>
In-Reply-To: <50E48D35.4000301@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.01.2013 20:40, schrieb Antti Palosaari:
> On 12/28/2012 01:02 AM, Frank Schäfer wrote:
>> The main purpose of this patch is to move the call of
>> em28xx_release_resources()
>> after the call of em28xx_close_extension().
>> This is necessary, because some resources might be needed/used by the
>> extensions
>> fini() functions when they get closed.
>> Also mark the device as disconnected earlier in this function and
>> unify the
>> em28xx_uninit_usb_xfer() calls for analog and digital mode.
>
> This looks like it could fix that one bug I reported earlier. Care to
> look these:
>
> em28xx releases I2C adapter earlier than demod/tuner/sec
> http://www.spinics.net/lists/linux-media/msg54693.html

Yes, this one gets fixed with the patch.

>
> em28xx #0: submit of audio urb failed
> http://www.spinics.net/lists/linux-media/msg54694.html

Seems to describe more than one bug.
What do mean with "when I plug em28xx device with analog support" ? Did
you mean "unplug" ?
Does this device use an external audio IC connected via i2c (e.g. EM202) ?
If yes, I think the patch should fix this issue, too.
Do you still have access to this device ? Can you test the patch ?

Regards,
Frank

>
>
> regards
> Antti
>

