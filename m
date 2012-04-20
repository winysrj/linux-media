Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34205 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2DTQuc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 12:50:32 -0400
Received: by yhmm54 with SMTP id m54so5278008yhm.19
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2012 09:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F917BD9.5070505@redhat.com>
References: <4F8EB1F1.1030801@gmail.com>
	<1334879437.14608.22.camel@palomino.walls.org>
	<CADbd7mHbP0YVQSBo4TgF0ZKqEU5VydWOoHZp__owh2b4k8aZsw@mail.gmail.com>
	<4F917BD9.5070505@redhat.com>
Date: Fri, 20 Apr 2012 13:50:31 -0300
Message-ID: <CALF0-+XpBL9cMzOyPZapXbv1gDSQ3n-v=gT1NHFd5zTEz9x+_g@mail.gmail.com>
Subject: Re: [PATCH] TDA9887 PAL-Nc fix
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Gonzalo A. de la Vega" <gadelavega@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hola ;)

>
> From other discussions we've had at the ML, it seems that devices sold in
> Argentina with analog tuners sometimes come with a NTSC tuner, and sometimes
> come with an European PAL tuner. They solve the frequency shifts that
> happen there via some tda9887 (and/or tuner-simple) adjustments.
>
> It seems that the setup, when using one type, is different than the other.
>
> That's why we need to know exactly what it is the tuner that your device
> has.
>
> So, from time to time, we receive patches from someone in Argentina fixing
> support for one type, but breaking support for the other type.
>
> What we need is that someone with technical expertise and with the two types
> of devices, with access to real PAL-Nc signals, to work on a solution that
> would set it accordingly, depending on the actual tuner used on it.
>

I live in Argentina, and have access to digital signal and some
tuners. Perhaps I could
help, provided someone cares to send me the relevant devices?

Gonzalo: What device is that?
