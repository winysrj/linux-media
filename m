Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54769 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IEQ21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 12:28:27 -0400
Received: by obbuo13 with SMTP id uo13so594300obb.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 09:28:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50477B20.1030902@samsung.com>
References: <CAOMZO5D7Ar0SE9vmi41jSxbPqv8sSOQshbL6Uzv4Ltow5xKx4w@mail.gmail.com>
	<50477B20.1030902@samsung.com>
Date: Wed, 5 Sep 2012 13:28:26 -0300
Message-ID: <CAOMZO5DOVnMC03AY+shAQBr-xyrsC+oX9OMxaa_dO3VJoDNx2w@mail.gmail.com>
Subject: Re: Camera not detected on linux-next
From: Fabio Estevam <festevam@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	=?UTF-8?Q?Ga=C3=ABtan_Carlier?= <gcembed@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wed, Sep 5, 2012 at 1:17 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:

> Maybe this is about the sensor/host driver linking order.
> If so, then this patch should help

Excellent! This fixed the problem!

Thanks,

Fabio Estevam
