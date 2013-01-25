Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757332Ab3AYNiB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 08:38:01 -0500
Message-ID: <51028B5D.8080607@redhat.com>
Date: Fri, 25 Jan 2013 14:40:45 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: partial revert of "uvcvideo: set error_idx properly"
References: <CAKbGBLiOuyUUHd+eEm+z=THEu57b2LSDFtoN9frXASZ5BG7Huw@mail.gmail.com> <20121225025648.5208189a@redhat.com> <510255BD.8060605@redhat.com> <201301251140.13707.hverkuil@xs4all.nl>
In-Reply-To: <201301251140.13707.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/25/2013 11:40 AM, Hans Verkuil wrote:

<snip>

>> What I did notice is that pwc_vidioc_try_fmt returns EINVAL when
>> an unsupported pixelformat is requested. IIRC we agreed that the
>> correct behavior in this case is to instead just change the
>> pixelformat to a default format, so I'll write a patch fixing
>> this.
>
> There are issues with that idea in the case of TV capture cards, since
> some important apps (tvtime and mythtv to a lesser extent) assume -EINVAL
> in the case of unsupported pixelformats.

Oh, I thought we agreed on never returning EINVAL accept for on invalid
buffer types in Barcelona ?

Regards,

Hans
