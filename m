Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757785Ab2IMMED (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 08:04:03 -0400
Message-ID: <5051CBFB.9030200@redhat.com>
Date: Thu, 13 Sep 2012 14:05:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pac7302-webcams and libv4lconvert interaction
References: <5048BDA2.7090203@googlemail.com> <504D080C.8020608@redhat.com> <504E0916.8010204@googlemail.com> <504E31F0.7080804@redhat.com> <504E4C96.8000207@googlemail.com> <504EE83C.5040503@redhat.com> <50509DDB.6030305@googlemail.com>
In-Reply-To: <50509DDB.6030305@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/12/2012 04:36 PM, Frank Schäfer wrote:

<snip>

>
> And a negative side effect is, that unknown pac7302 devices (with no
> V4LCONTROL_ROTATED_90_JPEG entry in libv4lconvert) do not work.
> With a consistent API behavior, they would work fine (output a rotated
> image). Users would at least know that their device is working and most
> of them know what to do next.
> For image rotation, we still need to add an entry to libv4lconvert and
> to modify it to invert the width and height values in v4l2_pix_format in
> this case.

That is a good point, unfortunately we are stuck with how we are doing
things now, since changing things would break the kernel ABI.

Also ...

>
> The device I have here is a good example: many people reported this
> device as not working years ago, one of them even got a hint in a forum
> that this could be a pac7302 device 2 years ago.
> But with the gpsca-pac7302 driver, he got no picture and gave up.
> And if I had not started q4vl2 from the terminal and had noticed the
> error message from libv4lconvert, I would have needed much more time to
> find out what's wrong...

True, OTOH just having this fixed won't help a regular user, as he/she
would still need to first add the new usb-id to the pac7302 driver...

Regards,

Hans
