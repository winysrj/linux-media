Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39516 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab2AKKoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 05:44:46 -0500
Received: by eekd4 with SMTP id d4so190175eek.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 02:44:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201110928280.1191@axis700.grange>
References: <1326250708-17643-1-git-send-email-festevam@gmail.com>
	<Pine.LNX.4.64.1201110928280.1191@axis700.grange>
Date: Wed, 11 Jan 2012 08:44:44 -0200
Message-ID: <CAOMZO5Byk=_jmymQLvxaxgv9mo5vcrD83HktBhmAGNTYbYkdQw@mail.gmail.com>
Subject: Re: [PATCH] drivers: video: mx3_camera: Convert mx3_camera to use module_platform_driver()
From: Fabio Estevam <festevam@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 11, 2012 at 6:28 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 11 Jan 2012, Fabio Estevam wrote:
>
>> Using module_platform_driver makes the code smaller and simpler.
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>
> Isn't this covered by this:
>
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/43200

Oh, you are right. Please discard my patch then.

Regards,

Fabio Estevam
