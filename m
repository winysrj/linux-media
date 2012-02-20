Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46256 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2BTSXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 13:23:23 -0500
Received: by eekc14 with SMTP id c14so2365651eek.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 10:23:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202201916410.2836@axis700.grange>
References: <1329761467-14417-1-git-send-email-festevam@gmail.com>
	<Pine.LNX.4.64.1202201916410.2836@axis700.grange>
Date: Mon, 20 Feb 2012 16:23:22 -0200
Message-ID: <CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 20, 2012 at 4:17 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 20 Feb 2012, Fabio Estevam wrote:
>
>> Align mx3_camera driver with the other soc camera driver implementations
>> by allocating the camera object via kzalloc.
>
> Sorry, any specific reason, why you think this "aligning" is so important?

Not really.

Just compared it with all other soc camera drivers I found and
mx3_camera was the only one that uses "vzalloc"

Any specific reason that requires mx3_camera to use "vzalloc" instead
of "kzalloc"?

Tested with kzalloc and it worked fine on my mx31pdk.

Regards,

Fabio Estevam
