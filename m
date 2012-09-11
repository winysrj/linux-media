Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab2IKH1t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 03:27:49 -0400
Message-ID: <504EE83C.5040503@redhat.com>
Date: Tue, 11 Sep 2012 09:29:00 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
CC: linux-media@vger.kernel.org
Subject: Re: pac7302-webcams and libv4lconvert interaction
References: <5048BDA2.7090203@googlemail.com> <504D080C.8020608@redhat.com> <504E0916.8010204@googlemail.com> <504E31F0.7080804@redhat.com> <504E4C96.8000207@googlemail.com>
In-Reply-To: <504E4C96.8000207@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/10/2012 10:24 PM, Frank Schäfer wrote:

<snip>

>
> libv4lconvert should be modifed to do the rotation regardless of what
> comes out of the kernel whenever V4LCONTROL_ROTATED flag is set.
> This way it becomes just a normal software control (like software h/v-flip).
> At the moment, it can only handle (jpeg) data where the kernel and
> header sizes are different.

And that cannot be done, because what if the app enumerates frame sizes, sees
640x480 there, then the rotate 90 degrees option gets toggled on, and it
starts streaming and gets 480x640 frames all of a sudden, or what if the rotation
changes during streaming ?

Which is exavtly the reason why rotated-90 is being handled the way it is, which
is I must admit a bit hacky, but that is what it is, just a hack for pac7302
cameras.

Doing general rotation support is hard, if not impossible, at the v4l2 level since
it changes not only the contents but also the dimensions of the image.

Regards,

Hans
