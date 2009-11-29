Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:62347 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZK2CaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 21:30:01 -0500
Received: by qw-out-2122.google.com with SMTP id 3so497205qwe.37
        for <linux-media@vger.kernel.org>; Sat, 28 Nov 2009 18:30:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1259353896-16892-1-git-send-email-ospite@studenti.unina.it>
References: <Pine.LNX.4.64.0911181110180.5702@axis700.grange>
	<1259353896-16892-1-git-send-email-ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sun, 29 Nov 2009 10:29:44 +0800
Message-ID: <f17812d70911281829h6f653c72q21ded878d1181bf7@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] pcm990-baseboard: don't use pxa_camera init()
	callback
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 4:31 AM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> pxa_camera init() is ambiguous, it's better to configure PXA CIF pins
> statically in machine init function.
>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

I'll grab this and get it exposed to next -rc phase.
