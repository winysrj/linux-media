Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab3AYJtN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 04:49:13 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0P9nCWr010631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 25 Jan 2013 04:49:12 -0500
Message-ID: <510255BD.8060605@redhat.com>
Date: Fri, 25 Jan 2013 10:51:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: partial revert of "uvcvideo: set error_idx properly"
References: <CAKbGBLiOuyUUHd+eEm+z=THEu57b2LSDFtoN9frXASZ5BG7Huw@mail.gmail.com> <CA+55aFxhXE8KbnjL7Nn3y0jd_wUFsdH6ZvsQ5EL+4cV3k3S4cg@mail.gmail.com> <20121224213948.36514eca@redhat.com> <20121225025648.5208189a@redhat.com>
In-Reply-To: <20121225025648.5208189a@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<modified the CC list to be more appropriate>

Hi,

On 12/25/2012 05:56 AM, Mauro Carvalho Chehab wrote:

> The pwc driver can currently return -ENOENT at VIDIOC_S_FMT ioctl. This
> doesn't seem right. Instead, it should be getting the closest format to
> the requested one and return 0, passing the selected format back to
> userspace, just like the other drivers do. I'm c/c Hans de Goede for him
> to take a look on it.

I've been looking into this today, and the ENOENT gets returned by
pwc_set_video_mode and through that by:
1) Device init
2) VIDIOC_STREAMON
3) VIDIOC_S_PARM
4) VIDIOC_S_FMT

But only when the requested width + height + pixelformat is an
unsupported combination, and it being a supported combination
already gets enforced by a call to pwc_get_size in
pwc_vidioc_try_fmt, which also gets called from pwc_s_fmt_vid_cap
before it does anything else.

So the ENOENT can only happen on some internal driver error,
I'm open for suggestions for a better error code to return in
this case.

What I did notice is that pwc_vidioc_try_fmt returns EINVAL when
an unsupported pixelformat is requested. IIRC we agreed that the
correct behavior in this case is to instead just change the
pixelformat to a default format, so I'll write a patch fixing
this.

Regards,

Hans
