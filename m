Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506Ab0A1MJW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 07:09:22 -0500
Message-ID: <4B617E96.2020903@redhat.com>
Date: Thu, 28 Jan 2010 13:09:58 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Setting up white balance on a t613 camera
References: <20100126170053.GA5995@pathfinder.pcs.usp.br>	<20100126193726.00bcbc00@tele>	<20100127163709.GA10435@pathfinder.pcs.usp.br>	<20100127171753.GA10865@pathfinder.pcs.usp.br> <20100127193728.0a75ba1e@tele>
In-Reply-To: <20100127193728.0a75ba1e@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/27/2010 07:37 PM, Jean-Francois Moine wrote:
> On Wed, 27 Jan 2010 15:17:53 -0200
> Nicolau Werneck<nwerneck@gmail.com>  wrote:
>
>> Answering my own question, and also a question in the t613 source
>> code...
>>
>> Yes, the need for the "reg_w(gspca_dev, 0x2087);", 0x2088 and 0x2089
>> commands are definitely tied to the white balance. These three set up
>> the default values I found out. And (X<<  8 + 87) sets up the red
>> channel parameter in general, and 88 is for green and 89 for blue.
>>
>> That means I can already just play with them and see what happens. My
>> personal problem is that I bought this new lens, and the image is way
>> too bright, and changing that seems to help. But I would like to offer
>> these as parameters the user can set using v4l2 programs. I can try
>> making that big change myself, but help from a more experienced
>> developer would be certainly much appreciated!...
>
> Hello Nicolau,
>
> The white balance is set in setwhitebalance(). Four registers are
> changed: 87, 88, 89 and 80.
>

Hi,

About whitebalancing, currently libv4l does whitebalancing completely
in software for camera's which cannot do it automatically in hardware.

That is libv4l calculates and applies 3 software gains to get
the average green red and blue values the same.

In the future it might be an idea to start supporting hardware per
color gains for this, but there are a number of issues with that:

1) The controls used for this then need to be standardized.
2) As we don't know the exact dB scale of the hardware gains we
need some sort of approximation algorithm, like with autogain /
exposure. Leading to potential overshoot, oscilating etc.

Esp 2. makes me wonder if we want to use the hardware color gains
(when the hardware cannot autoadjust them) at all. Calculating
a software gain so that the averages become equal is trivial, and
does not need any settling time etc.

Note that in case of whitebalance the color correction gain can
easily be done in software (as it is in the range of circa 0.7 - 1.3)
unlike things like exposure and the main gain which we really
must set correctly at the hardware level for a usable picture.

To give libv4l's software whitebalance a try do:

export LIBV4LCONTROL_FLAGS=8

And then run a webcam viewing app from the same commandline

You can also run a control panel like v4l2ucp like this:
export LIBV4LCONTROL_FLAGS=8
LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so v4l2ucp

To get a whitebalance control with which you can toggle
the whitebalance on/off while streaming so that you can
see the effect it has on the picture.

Regards,

Hans
