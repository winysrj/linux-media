Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab2EEO7d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 May 2012 10:59:33 -0400
Message-ID: <4FA54052.1090009@redhat.com>
Date: Sat, 05 May 2012 16:59:30 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 1/7] gspca: allow subdrivers to use the control
 framework.
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl> <201205051034.30484.hverkuil@xs4all.nl> <4FA53D48.6020004@redhat.com> <201205051650.03626.hverkuil@xs4all.nl>
In-Reply-To: <201205051650.03626.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/05/2012 04:50 PM, Hans Verkuil wrote:
> On Sat May 5 2012 16:46:32 Hans de Goede wrote:
>> Hi,
>>
>> On 05/05/2012 10:34 AM, Hans Verkuil wrote:
>>> On Sat May 5 2012 09:43:01 Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> I'm slowly working my way though this series today (both review, as well
>>>> as some tweaks and testing).
>>>
>>> Thanks for that!
>>>
>>> One note: I initialized the controls in sd_init. That's wrong, it should be
>>> sd_config. sd_init is also called on resume, so that would initialize the
>>> controls twice.
>>
>> You cannot move the initializing of the controls to sd_config, since in many
>> cases the sensor probing is done in sd_init, and we need to know the sensor
>> type to init the controls.
>
> Or you move the sensor probing to sd_config as I did. It makes no sense
> anyway to do sensor probing every time you resume.
>
> Unless there is another good reason for doing the probing in sd_init I prefer
> to move it to sd_config.

Sensor probing does more then just sensor probing, it also configures
things like the i2c clockrate, and if the bus between bridge and sensor
is spi / i2c or 3-wire, or whatever ...

After a suspend resume all bets are of wrt bridge state, so we prefer to
always do a full re-init as we do on initial probe, so that we (hopefully)
will put the bridge back in a sane state.

I think moving the probing from init to config is a bad idea, the chance
that we will get regressions (after a suspend/resume) from this are too
big IMHO.

Regards,

Hans
