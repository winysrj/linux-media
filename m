Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:58284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1BNTI6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 14:08:58 -0500
Message-ID: <4D598080.2070100@redhat.com>
Date: Mon, 14 Feb 2011 20:20:32 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l-utils: Add the JPEG Lite decoding function
References: <20110214133643.3c9d1454@tele>
In-Reply-To: <20110214133643.3c9d1454@tele>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 02/14/2011 01:36 PM, Jean-Francois Moine wrote:
> Hi Hans,
>
> JPEG Lite images are created by the DivIO nw80x chips.
>
> The gspca subdriver nw80x will be ready soon.
>
> Decoding to RGB24 and BGR24 are ok. Decoding to YUV420 and YVU420 are
> not tested.
>

You're working on nw80x support? Cool! I've a cam with one of
those chipsets lying around, it is a Dynalink 06be:d001. I'll definitely
give the driver a try when it hits your git tree, or send it
my way if you wanted it tested with this cam earlier.

Now about the libv4l patch, unfortunately it cannot go in as is.
The problem is that the code you derived it from seems to be GPL
not LGPL (judging from the copyright header you put on top of it),
and libv4l is LGPL, and has to be to to allow it to be used with
for example skype and flash. The thing to do here is to try
and contact the original author and get permission to relicense
under the LGPL (version 2 or later). In the mean time the code
can still go in but as an external helper, see for example the
ov511 and ov518 decompression code. There is a generic external
helper framework in libv4l, so the needed code changes should
be minimal.

Thanks & Regards,

Hans
