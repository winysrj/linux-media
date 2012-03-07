Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35224 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635Ab2CGOcY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Mar 2012 09:32:24 -0500
Received: by obbuo6 with SMTP id uo6so6978129obb.19
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2012 06:32:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F572611.50607@redhat.com>
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
	<4F572611.50607@redhat.com>
Date: Wed, 7 Mar 2012 11:32:23 -0300
Message-ID: <CALF0-+V5kTMXZ+Nfy4yqOSgyMwBYmjGH4EfFbqjju+d3GdsvSA@mail.gmail.com>
Subject: Re: A second easycap driver implementation
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>
> Have you considered instead slowly moving the existing easycap driver
> over to all the new infrastructure we have now. For starters replace
> its buffer management with videobuf2, then in another patch replace
> some other bits, etc. ?  See what I've done to the pwc driver :)

Yes. And that was what I was doing until now.
Yet, after some work it seemed much easier
to simply start over from scratch.

Besides, it's being a great learning experience :)

So, since the driver is not yet working I guess there
is no point in submitting anything.

Instead, anyone the wants to help I can send what I have now
or we can start working through github.
If someone owns this device, it would be a *huge* help
with testing.

However, as soon as this is capturing video I would like
to put it on staging, so everyone can help.
Is this possible?

Thanks,
Ezequiel.
