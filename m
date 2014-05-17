Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:41116 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964856AbaEQRwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 May 2014 13:52:18 -0400
Message-ID: <5377A1CC.7020104@posteo.de>
Date: Sat, 17 May 2014 19:52:12 +0200
From: Martin Kepplinger <martink@posteo.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, gregkh@linuxfoundation.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] staging: media: as102: replace custom dprintk() with
 dev_dbg()
References: <53776B57.5050504@iki.fi> <1400342738-32652-1-git-send-email-martink@posteo.de> <53779A7F.8020007@iki.fi>
In-Reply-To: <53779A7F.8020007@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 2014-05-17 19:21, schrieb Antti Palosaari:
> On 05/17/2014 07:05 PM, Martin Kepplinger wrote:
>> don't reinvent dev_dbg(). remove dprintk() in as102_drv.c.
>> use the common kernel coding style.
>>
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> 
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> 
>> ---
>> this applies to next-20140516. any more suggestions?
>> more cleanup can be done when dprintk() is completely gone.
> 
> Do you have the device? I am a bit reluctant patching that driver
> without any testing as it has happened too many times something has gone
> totally broken.
I don't have the device and will, at most, change such style issues.

> 
> IIRC Devin said it is in staging because of style issues and nothing
> more. Is that correct?
I haven't heard anything. A TODO file would help.

> 
> regards
> Antti
> 

