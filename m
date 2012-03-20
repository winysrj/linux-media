Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48250 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2CTMpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 08:45:07 -0400
Received: by eaaq12 with SMTP id q12so2976634eaa.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 05:45:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1203201340300.21870@axis700.grange>
References: <1329761467-14417-1-git-send-email-festevam@gmail.com>
	<Pine.LNX.4.64.1202201916410.2836@axis700.grange>
	<CAOMZO5AAeqHZFqpZYB_riSCQvCRSjQtR2EqpZvC5V3TRyzuWJQ@mail.gmail.com>
	<4F67E4FD.2070709@redhat.com>
	<Pine.LNX.4.64.1203200851300.20315@axis700.grange>
	<CAOMZO5CJHkb1JrAd+DYvYP-DrV6XsqO3wtoxJGe_s9sE1tQktw@mail.gmail.com>
	<Pine.LNX.4.64.1203201340300.21870@axis700.grange>
Date: Tue, 20 Mar 2012 09:45:05 -0300
Message-ID: <CAOMZO5B=0LMqi-v-KwJkvsBEqUU+Bj8TRo08i7zGSv97jnZpVQ@mail.gmail.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/20/12, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

>> Is this valid only for mx3_camera driver?
>
> No
>
>> All other soc camera drivers use kzalloc.
>>
>> What makes mx3_camera different in this respect?
>
> Nothing

Ok, so isn't my patch correct then?
