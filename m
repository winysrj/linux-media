Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:25830
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761414AbZAPVJH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 16:09:07 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: video4linux-list@redhat.com, Olivier Lorin <o.lorin@laposte.net>,
	linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>,
	kilgota@banach.math.auburn.edu
Subject: Re: RFC: Where to store camera properties (upside down, needs sw whitebalance, etc). ?
Date: Fri, 16 Jan 2009 20:58:35 +0000
References: <31415843.70859.1232106194273.JavaMail.www@wwinf8401>
In-Reply-To: <31415843.70859.1232106194273.JavaMail.www@wwinf8401>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901162058.36080.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 January 2009, Olivier Lorin wrote:
<snip discussion of cameras needing image flipping capability in libv4l>
> The use of the buffer flags makes the life easier as this flag
> is read for every image. So we can solve for the flip/rotation
> issues with the help of two new buffer flags: V4L2_BUF_FLAG_NEEDS_HFLIP
> and V4L2_BUF_FLAG_NEEDS_VFLIP.
>
> A driver has to set them properly. Does the rotation or flip(s)
> apply to every image (e.g. sensor upside down) or change with frames
> (e.g. Genesys webcams), that no more matters .
> I can do the patch these days.
> I do not remember if there is h/v flip functions in the libv4l,
> maybe they have to be added.
>
> Regards,
> Nol

That sounds like a sensible approach. The flip code is already in libv4l  but 
is currently controlled by a static table (v4lconvert_flags) of cameras that 
need it.

It doesn't address the issue of whether libv4l should also provide gamma 
adjustment, auto white balance and auto gain for cameras that could benefit 
from it. Again that could be done with a static table but keeping the 
knowledge in libv4l in step with the list of supported cameras in the kernel 
won't be easy.

Adam
