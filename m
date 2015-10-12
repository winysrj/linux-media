Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52881 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbbJLKYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 06:24:48 -0400
Message-ID: <561B89FD.4010802@xs4all.nl>
Date: Mon, 12 Oct 2015 12:22:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC] ADV7604: VGA support
References: <CAH-u=81zwkTxjYEsO8rNLf687-nGuj3DdJNeF6bmnxSUSVYQQg@mail.gmail.com>
In-Reply-To: <CAH-u=81zwkTxjYEsO8rNLf687-nGuj3DdJNeF6bmnxSUSVYQQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/04/2015 06:17 PM, Jean-Michel Hautbois wrote:
> Hi,
> 
> I had another look into the ADV7604 HW manual, and I understand that
> in automatic mode, there is 4 AIN_SEL values possible, determining the
> connection on AIN pins.
> Now, having a look at the current ADV76xx files, I can see that two
> pads are there :
> ADV7604_PAD_VGA_RGB and ADV7604_PAD_VGA_COMP.
> 
> According to the manual, my understanding is that we should have four
> HDMI pads and four analog pads. The latter would be configured as RGB
> or component, which allows four analog inputs as described in the HW
> manual.

When I wrote the driver we only needed one VGA input receiving either RGB
or YCbCr. Hence there is only one analog input and two pads. I wouldn't have
been able to test the additional analog inputs anyway.

I chose to use pads to select between the two modes, but that's something
that can be changed (it's not something you can autodetect, unfortunately).

If you want to add support for all four analog inputs, then feel free to
do so.

Regards,

	Hans

> 
> I don't know if you agree with that or if you had something else in
> mind when designing it in the first place, I may have missed something
> (Lars :) ?).
> 
> Thanks,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

