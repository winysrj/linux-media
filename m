Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:33623 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3DMPey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 11:34:54 -0400
Received: by mail-qc0-f176.google.com with SMTP id n41so1612297qco.35
        for <linux-media@vger.kernel.org>; Sat, 13 Apr 2013 08:34:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51697A29.5030307@googlemail.com>
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
	<51695A7B.4010206@iki.fi>
	<20130413112517.40833d48@redhat.com>
	<51697A29.5030307@googlemail.com>
Date: Sat, 13 Apr 2013 11:34:53 -0400
Message-ID: <CAGoCfiwO+98ZkSt-mY6U3nnfge43xy+1WLEv=3wUf6SaDEgACQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 13, 2013 at 11:30 AM, Frank Schäfer
<fschaefer.oss@googlemail.com> wrote:
> I've checked the documentation about the gpio and led frameworks a few
> weeks ago to find out if it makes sense to use them for the
> gpio/buttons/led stuff of the VAD Laplace webcam.
> AFAICS, there are no benfits as long as you are dealing with these
> things internally. It just increases the code size and adds an
> additional dependency in this case.
> Of course, the situation is different when there is an interaction with
> other modules or userspace. In that case using gpiolib could make sense.
> I don't know which case applies to the LAN stuff, but for the
> buttons/leds it's the first case.

IMHO, it would be a bad idea to expose the actual GPIOs to userspace.
Improperly setting the GPIOs can cause damage to the board, and all of
the functionality that the GPIOs control are exposed through other
much better supported interfaces.  It's a nice debug feature for
driver developers who want to hack at the driver, but you really don't
want any situation where end users or applications are making direct
use of the GPIOs.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
