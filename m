Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab1L3Szw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 13:55:52 -0500
Message-ID: <4EFE0967.6020904@redhat.com>
Date: Fri, 30 Dec 2011 19:56:39 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: "'Sakari Ailus'" <sakari.ailus@iki.fi>
CC: "HeungJun, Kim" <riverful.kim@samsung.com>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Sylwester Nawrocki'" <snjw23@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-2-git-send-email-riverful.kim@samsung.com> <4EFB1B04.6060305@gmail.com> <201112281451.39399.laurent.pinchart@ideasonboard.com> <20111229233406.GU3677@valkosipuli.localdomain> <000801ccc6bd$4b844520$e28ccf60$%kim@samsung.com> <4EFD7955.8070603@redhat.com> <20111230184212.GW3677@valkosipuli.localdomain>
In-Reply-To: <20111230184212.GW3677@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/30/2011 07:42 PM, 'Sakari Ailus' wrote:
> Hi Hans,
>
> On Fri, Dec 30, 2011 at 09:41:57AM +0100, Hans de Goede wrote:
> ...
>> Right, so the above is exactly why I ended up making the pwc whitebalance
>> control the way it is, the user can essentially choice between a number
>> of options:
>> 1) auto whitebal
>> 2) a number of preset whitebal values (seems your proposal has some more then the pwc
>>     driver, which is fine)
>> 3) manual whitebal, at which point the user may set whitebal through one of:
>>     a) a color temperature control
>>     b) red and blue balance controls
>>     c) red, green and blue gains
>
> d) red, green, blue and... another green. This is how some raw bayer sensors
> can be controlled.
>

Yes, but have you ever tried setting the 2 green gains to different values?
(Hint the result is not pretty) I strongly believe the 2 separate green gains are
only there as it is easier to do things that way (it keeps the sensor array symmetric) and
there is no value in controlling them separately.

>> Notice that we also need to add some standardized controls for the 3c case, but that
>> is a different discussion.
>
> I was planning to add the gain to low-level controls once the other  sensor
> controls have been properly discussed, and hopefully approved, first.
>
>> Seeing how this discussion has evolved I believe that what I did in the pwc driver
>> is actually right from the user pov, the user gets one simple menu control which
>> allows the user to choice between auto / preset 1 - x / manual and since as
>> described above choosing one of the options excludes the other options from being
>> active I believe having this all in one control is the right thing to do.
>
> I still think automatic white balance should be separate from the rest, as
> it currently is (V4L2_CID_AUTO_WHITE_BALANCE). If such presets aren't
> available, the way the user would enable automatic white balance changes,
> which is bad.

Well we can just put in the spec that the control can be either a boolean or
a menu control depending on if it has presets. I really believe that we should
not make this 2 separate controls, it does not match from a user pov.

There are 2 things which the user wants to control here:

1) How the value of the white balance controls gets controlled, which is
one of: a) auto b) select values from preset 1 - # c) manaul

2) The white balance controls themselves (temperature, or color balances ...),
but only if 1) is set to manual

There is no reason to separate 1) in 2 separate controls, that will only serve
to confuse the user.

As for the theoretical automatic wb which takes some hints like the presets,
AFAIK no such device exists and it is unlikely one will show up in the near
future. IOW it is purely theoretical and thus not interesting.

Regards,

Hans
