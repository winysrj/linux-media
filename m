Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56493 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2GWMfP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jul 2012 08:35:15 -0400
Received: by vcbfk26 with SMTP id fk26so4643655vcb.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jul 2012 05:35:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207201105.45303.hverkuil@xs4all.nl>
References: <CAGzWAsg3hsGV5CPsCzxcKO4djG4iRZauEQvju=G=Zp4Rpqpz2g@mail.gmail.com>
	<201207191606.21244.hverkuil@xs4all.nl>
	<CAGzWAsjxOHkccZstHfiqNKhLNCNMRoCsswP8vNOEDeE-FSHVug@mail.gmail.com>
	<201207201105.45303.hverkuil@xs4all.nl>
Date: Mon, 23 Jul 2012 18:05:14 +0530
Message-ID: <CAGzWAsg2fhmxDshtruGm90YAiVbHis7hEuE_BZRFBV_PPa-h7g@mail.gmail.com>
Subject: Re: Supporting 3D formats in V4L2
From: Soby Mathew <soby.linuxtv@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
 Thanks for the reply and I was going through the HDMI1.4 spec again.
The 'active space' is part of the Vactive and Vactive is sum of active
video and active space.

> No, as I understand it active_space is just part of the active video. So the
> timings struct is fine, it's just that the height parameter for e.g. 720p in
> frame pack format is 2*720 + vfrontporch + vsync + vbackporch. That's the height
> of the frame that will have to be DMAed from/to the receiver/transmitter.

In this case (assuming frame packed) the total height should be 2*720
+ 30 +  vfrontporch + vsync + vbackporch.

Sorry, but if I am understanding you correct, in case of 3D frame
packed format, the height field can be 'active video + active space'.
So the application need to treat the buffers appropriately according
to the 3D format detected. Would this be a good solution?


> I think the only thing that needs to be done is that the appropriate timings are
> added to linux/v4l2-dv-timings.h.

Yes , the standard 3 D timings need to be added to this file which can
be taken up.

> Regards,
>
>         Hans
>


Best Regards
Soby Mathew
