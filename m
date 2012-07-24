Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58101 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2GXV74 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 17:59:56 -0400
Received: by gglu4 with SMTP id u4so58150ggl.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 14:59:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500F18A5.4010602@iki.fi>
References: <20120713173708.GB17109@thunk.org>
	<5005A14D.8000809@redhat.com>
	<201207242305.08220.remi@remlab.net>
	<CAGoCfiwE1pfCxuE3WS3FwOV2jnxMFxhnL6-+hTSfE+2PNnxk-g@mail.gmail.com>
	<500F18A5.4010602@iki.fi>
Date: Tue, 24 Jul 2012 17:59:55 -0400
Message-ID: <CAGoCfiz4xVUe7Q_SKhi6fOcfa4Pay5DEz5DX=9KZNh56cP33Gg@mail.gmail.com>
Subject: Re: Media summit at the Kernel Summit - was: Fwd: Re:
 [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2012 at 5:50 PM, Antti Palosaari <crope@iki.fi> wrote:
> I wonder if it is wise to merge both DVB and V4L2 APIs, add needed DVB stuff
> to V4L2 API and finally remove whole DVB API. V4L2 API seems to be much more
> feature rich, developed more actively and maybe has less problems than
> current DVB API.

This may just be a case of "the grass is always greener on the other
side of the fence".  The V4L2 subsystem has more than it's share of
problems - you just don't see them since you don't work with that code
on a regular basis.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
