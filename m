Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35208 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbF3BUd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 21:20:33 -0400
Received: by igblr2 with SMTP id lr2so64842538igb.0
        for <linux-media@vger.kernel.org>; Mon, 29 Jun 2015 18:20:32 -0700 (PDT)
Date: Tue, 30 Jun 2015 09:20:38 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Ole Ernst" <olebowle@gmx.com>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Dirk Nehring" <dnehring@gmx.net>
References: <201506292209394689855@gmail.com>
Subject: Re: Re: [PATCH 1/1] SMI PCIe IR driver for DVBSky cards
Message-ID: <201506300920353282196@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Ole,

Due to the hardware limitation, it can not support arbitrary IR codes.
The current patch supports RC5 only.

On 2015-06-29 22:40:04, Ole Ernst <olebowle@gmx.com> wrote:
>Hi Max,
>
>Am 29.06.2015 um 16:09 schrieb Nibble Max:
>> ported from the manufacturer's source tree, available from
>> http://dvbsky.net/download/linux/media_build-bst-150211.tar.gz
>> 
>> This is the second patch after a public review.
>
>just for the sake of clarity: I see commented out bits and pieces of
>RC_DRIVER_IR_RAW in your linked archive. Does this mean S950/S952/T9580
>V3 models theoretically support arbitrary IR codes, but with this patch
>only RC5 is implemented? Or are those models only able to handle RC5?
>
>Regards,
>Ole

Best Regards,
Max

