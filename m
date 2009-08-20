Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:32305 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbZHTX2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 19:28:13 -0400
Received: by qw-out-2122.google.com with SMTP id 8so183878qwh.37
        for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 16:28:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908201909.38313.ronny.brendel@tu-dresden.de>
References: <200908201909.38313.ronny.brendel@tu-dresden.de>
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
Date: Fri, 21 Aug 2009 08:27:54 +0900
Message-ID: <5e9665e10908201627r3a2b6012xf96345ffa7913b54@mail.gmail.com>
Subject: Re: What is V4L2_CTRL_TYPE_BUTTON?
To: Ronny Brendel <ronny.brendel@tu-dresden.de>
Cc: linux-media@vger.kernel.org, Ronny Brendel <ronnybrendel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 21, 2009 at 2:09 AM, Ronny
Brendel<ronny.brendel@tu-dresden.de> wrote:
> According to the spec it is """A control which performs an action when set.
> Drivers must ignore the value passed with VIDIOC_S_CTRL and return an EINVAL
> error code on a VIDIOC_G_CTRL attempt."""
>
> I don't get what this means. It is no boolean. It has no effect, and you cannot
> set it? I am probably missing something. Please help.
>

Hi,

This exactly what I wondered several months ago :-)
Recalling the memory back then, the answer was that the button type is
just a command to trigger some functionality which doesn't care about
parameters because that is actually not necessary.
For instance, "adjusting white balance" button in digital camera could
be a good example which is performing adjustment of white balance for
one time and no need for any kind of parameter for this but needs to
be triggered.
Cheers,

Nate

-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
