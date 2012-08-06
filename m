Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756306Ab2HFOIm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 10:08:42 -0400
Message-ID: <501FCFE1.7010802@redhat.com>
Date: Mon, 06 Aug 2012 11:08:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Takashi Iwai <tiwai@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v8] media: Add stk1160 new driver
References: <1344260302-28849-1-git-send-email-elezegarcia@gmail.com> <CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com>
In-Reply-To: <CALF0-+Xwa6qNH3pEOgJq9f07C+ArNco6nxQcjGWoy5kwyQeScA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 10:58, Ezequiel Garcia escreveu:
> Hi Mauro,
> 
> On Mon, Aug 6, 2012 at 10:38 AM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> This driver adds support for stk1160 usb bridge as used in some
>> video/audio usb capture devices.
>> It is a complete rewrite of staging/media/easycap driver and
>> it's expected as a replacement.
>> ---
>>
> 
> I just sent v8, but it looks it wasn't received by patchwork either.
> 
> What's going on?

The patch didn't arrive at linux-media ML.

Not sure why it got rejected at vger. I suggest you to ping vger admin
to see why your patches are being rejected there.

I tested parsing this patch manually and patchwork accepted. So, once
the issue with vger is solved, other patches should be properly
handled there.

Regards,
Mauro
