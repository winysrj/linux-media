Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab2CGJJD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 04:09:03 -0500
Message-ID: <4F572611.50607@redhat.com>
Date: Wed, 07 Mar 2012 10:10:41 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
CC: Tomas Winkler <tomasw@gmail.com>, Greg KH <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: A second easycap driver implementation
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
In-Reply-To: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 03/06/2012 10:04 PM, Ezequiel García wrote:
> Hello,
>
> After some research on v4l2 and videbuf2, and considering that easycap
> driver is pretty
> outdated I've decided to start writing a new driver from scratch.
>
> I am using the excellent vivi driver and some usb video capture drivers as
> a starting point. And of course, I'm using the current easycap implementation
> as a reference (it works pretty well).
>
> I have a couple of doubts regarding the development itself (how to
> trace properly,
> where to allocate urbs, and such) but perhaps the maintainers prefer
> to take a look
> at the code.
>
> However, currently the driver is just a skeleton: it does all v4l2 and
> videobuf2 intialization
> but it doesn't actually stream video or submit urbs.
>
> So,
> 1. Should I try to have something more finished before submit or can I
> submit as it is?
> 2. In any case, how should I submit it? (Considering there is already
> a working driver).

Have you considered instead slowly moving the existing easycap driver
over to all the new infrastructure we have now. For starters replace
its buffer management with videobuf2, then in another patch replace
some other bits, etc. ?  See what I've done to the pwc driver :)

OTOH if you already have a new more modern driver ready, then I say
go ahead and submit it. I would suggest to add it to staging too,
and make the 2 kconfig options conflict, so enabling one would allow
the user to no longer select the other (with a note about this in
the help text). And then hopefully soon we will see a follow up
patch removing the old driver, and then moving the new one out
of staging.

Which ever path you choose: Thanks for working on this!

Regards,

Hans
