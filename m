Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab1L3IlK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 03:41:10 -0500
Message-ID: <4EFD7955.8070603@redhat.com>
Date: Fri, 30 Dec 2011 09:41:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: "HeungJun, Kim" <riverful.kim@samsung.com>
CC: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Sylwester Nawrocki'" <snjw23@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <1325053428-2626-2-git-send-email-riverful.kim@samsung.com> <4EFB1B04.6060305@gmail.com> <201112281451.39399.laurent.pinchart@ideasonboard.com> <20111229233406.GU3677@valkosipuli.localdomain> <000801ccc6bd$4b844520$e28ccf60$%kim@samsung.com>
In-Reply-To: <000801ccc6bd$4b844520$e28ccf60$%kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/30/2011 07:35 AM, HeungJun, Kim wrote:
> Hi Sakari,
>
> Thanks for the comments!
>
> Your comments help me to order my thoughts and re-send RFC.
>

<snip>

>> The value of the new control would have an effect as long as automatic white
>> balance is enabled.
> No, it's a kind of Manual White Balance, not Auto. It's the same level of
> V4L2_CID_WHITE_BALANCE_TEMPERATURE. So, only when V4L2_CID_AUTO_WHITE_BALANCE is
>
> disabled, this control is enabled.
>
> The relationship between each white balance controls by my understanding is
> here.
>
> Auto White Balance
>    - V4L2_CID_AUTO_WHITE_BALANCE(Boolean)
>      : enable/disable Auto white balance.
>      : Enable means current mode is Auto, and disable means current mode is
> Manual
>
> Manual White Balance
>    - V4L2_CID_WHITE_BALANCE_TEMPERATURE(integer)
>      : Setting the temperature of Manual
>      : Only when the V4L2_CID_AUTO_WHITE_BALANCE is disabled, and current mode
> Manual.
>
> - V4L2_CID_WHITE_BALANCE_PRESET(menu) - I suggested
>      : Setting the specific temperature value(but, the value is not fetched by
> user) of Manual
>      : Only when the V4L2_CID_AUTO_WHITE_BALANCE is disabled, and current mode
> Manual.
>
> The "input" is right. And, this "input" just triggers the ISP(sensor) set the
> specific
> manual white balance value embedded in the ISP.
> I think this control does not affect the Auto White Balance.

Right, so the above is exactly why I ended up making the pwc whitebalance
control the way it is, the user can essentially choice between a number
of options:
1) auto whitebal
2) a number of preset whitebal values (seems your proposal has some more then the pwc
    driver, which is fine)
3) manual whitebal, at which point the user may set whitebal through one of:
    a) a color temperature control
    b) red and blue balance controls
    c) red, green and blue gains

Notice that we also need to add some standardized controls for the 3c case, but that
is a different discussion.

Seeing how this discussion has evolved I believe that what I did in the pwc driver
is actually right from the user pov, the user gets one simple menu control which
allows the user to choice between auto / preset 1 - x / manual and since as
described above choosing one of the options excludes the other options from being
active I believe having this all in one control is the right thing to do.

Regards,

Hans
