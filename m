Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:47128 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245Ab3JQVqg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 17:46:36 -0400
Received: by mail-qe0-f51.google.com with SMTP id q19so1116962qeb.10
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 14:46:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526001DF.9040309@samsung.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
	<1381362589-32237-4-git-send-email-sheu@google.com>
	<52564DE6.6090709@xs4all.nl>
	<CAErgknA-3bk1BoYa6KJAfO+863DBTi_5U8i_hh7F8O+mXfyNWg@mail.gmail.com>
	<CAErgknA-ZgSzeeaaEuYKFZ0zonCt=10tBX7FeOT16-yQLZVnZw@mail.gmail.com>
	<52590184.5030806@xs4all.nl>
	<CAErgknAXZzbBMm0JeASOVzsXNNyu7Af32hd0t_fR8VkPeVrx4A@mail.gmail.com>
	<526001DF.9040309@samsung.com>
Date: Thu, 17 Oct 2013 14:46:35 -0700
Message-ID: <CAErgknCu2UeEQeY+taSXAbC6F4i=FMTz8t=MhSLUdfQRZXQgAg@mail.gmail.com>
Subject: Re: Fwd: [PATCH 3/6] [media] s5p-mfc: add support for
 VIDIOC_{G,S}_CROP to encoder
From: John Sheu <sheu@google.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, Kamil Debski <k.debski@samsung.com>,
	pawel@osciak.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 17, 2013 at 8:27 AM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
>
> Hello John,
>
> I am a designer of original selection API. Maybe I could clarify what
> does what in VIDIOC_S_CROP ioctl.
>
> <snip>
>

Sweet.  Thanks for spelling things out explicitly like this.  The fact
that the CAPTURE and OUTPUT queues "invert" their sense of "crop-ness"
when used in a m2m device is definitely all sorts of confusing.

I'll have an updated patch shortly.

-John Sheu
