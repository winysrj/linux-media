Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36290 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbbCEI6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 03:58:17 -0500
Date: Thu, 5 Mar 2015 08:58:11 +0000 (GMT)
From: William Towle <william.towle@codethink.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Subject: Re: [Linux-kernel] RFC: supporting adv7604.c under
 soc_camera/rcar_vin
In-Reply-To: <54F6DC4F.6040504@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1503050847040.4771@xk120.dyn.ducie.codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk> <alpine.DEB.2.02.1503040911560.4552@xk120.dyn.ducie.codethink.co.uk> <54F6DC4F.6040504@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 4 Mar 2015, Hans Verkuil wrote:
> On 03/04/15 10:51, William Towle wrote:
>>     if (timings->pad >= state->source_pad)
>>             return -EINVAL;
>>   It suffices to comment out this line, but clearly this is not ideal.
>> Depending on the intended semantics, should it be filtering out all pad
>> IDs not matching the active one, or all pad IDs that are not valid
>> input sources? Unfortunately the lager board's adv7180 chip is too
>> simple to make a sensible comparison case (that we can also run tests
>> on) here.
>
> The adv7604 code is not ideal, although the pad test is valid (you shouldn't
> be able to ask timings for pads that do not exist).

   Right, thanks. It seems I have initialisation code that is making
inappropriate assumptions earlier on. I'll investigate this.


>>   Please advise. Comments would also be welcome regarding whether the
>> shims describe changes that should live in the driver or elsewhere in
>> soc_camera/rcar_vin in an acceptable solution.
>
> I'm not entirely sure what it is you are referring to.

   Amongst our various modifications to soc_camera/rcar_vin we have a
'struct media_pad' object in order to communicate with the adv7604
driver, and latterly an array of 'struct v4l2_subdev_pad_config's to
handle format information ... but there is more to be done, obviously,
and you have pointed us in the right direction above :)

Cheers,
   Wills.
