Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:21850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab0IGJgl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Sep 2010 05:36:41 -0400
Message-ID: <4C860903.10002@redhat.com>
Date: Tue, 07 Sep 2010 11:42:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Illuminators and status LED controls
References: <20100906201105.4029d7e7@tele> <201009070930.55807.hverkuil@xs4all.nl>
In-Reply-To: <201009070930.55807.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 09/07/2010 09:30 AM, Hans Verkuil wrote:
> On Monday, September 06, 2010 20:11:05 Jean-Francois Moine wrote:
>> Hi,
>>
>> This new proposal cancels the previous 'LED control' patch.
>>
>> Cheers.
>>
>>
>
> Hi Jean-Francois,
>
> You must also add support for these new controls in v4l2-ctrls.c in
> v4l2_ctrl_get_menu(), v4l2_ctrl_get_name() and v4l2_ctrl_fill().
>
> How is CID_ILLUMINATORS supposed to work in the case of multiple lights?
> Wouldn't a bitmask type be more suitable to this than a menu type? There
> isn't a bitmask type at the moment, but this seems to be a pretty good
> candidate for a type like that.
>
> Actually, for the status led I would also use a bitmask since there may be
> multiple leds. I guess you would need two bitmasks: one to select auto vs
> manual, and one for the manual settings.
>

So far I've not seen cameras with multiple status leds, I do have seen camera
which have the following settings for their 1 led (logitech uvc cams):
auto
on
off
blinking

So I think a menu type is better suited, and that is what the current (private)
uvc control uses.

Regards,

Hans
