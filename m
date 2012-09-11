Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab2IKHcY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 03:32:24 -0400
Message-ID: <504EE94E.9050800@redhat.com>
Date: Tue, 11 Sep 2012 09:33:34 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] libv4lconvert: pac7302-devices: remove unneeded flag
 V4LCONTROL_WANTS_WB
References: <1347215768-9843-1-git-send-email-fschaefer.oss@googlemail.com> <1347215768-9843-2-git-send-email-fschaefer.oss@googlemail.com> <504D08F8.3070104@redhat.com> <504E0A13.2050305@googlemail.com> <504E3275.8010806@redhat.com> <504E4E83.4050706@googlemail.com>
In-Reply-To: <504E4E83.4050706@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/10/2012 10:33 PM, Frank Schäfer wrote:

<snip>

>>> And if AWB is on, the WB control should be disabled, right ?
>>
>> No, the software AWB works by applying software rgb gains, so the
>> hardware
>> control is still useful, as the better the color balance of the input,
>> the better the end-result will be.
>
> Hmm... auto-whitebalance should compensate the setting made with the
> manual hardware controlled whitebalance.

In an ideal world, yes. But that would only work if we know the exact
units in which the controls operate, and we don't. Also notice that even
if we had some sort of feedback looped software awb algorithm to get
over the units issue, the pac7302 is really funky in that it has both
blue / red balance controls and a color temperature control, so which
of those should such a software awb control ?

> But I guess they are working too differenty.

Right, the advantage of doing software whitebalance using software rgb
gains, is that we know the units of the software gains, so we don't need
a feedback loop, instead we just measure which correction we think we
should apply, and then apply it "blindly" (so without any feedback loop).

Regards,

Hans
