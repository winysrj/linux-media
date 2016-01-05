Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37523 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbcAERjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 12:39:06 -0500
Received: by mail-wm0-f42.google.com with SMTP id f206so40386586wmf.0
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2016 09:39:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cc589da759a48477b8283eba3b61568f85ca14ef.1449843997.git.mchehab@osg.samsung.com>
References: <cc589da759a48477b8283eba3b61568f85ca14ef.1449843997.git.mchehab@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 5 Jan 2016 17:38:34 +0000
Message-ID: <CA+V-a8uXR4srwvWk9QJhvXcbLn2UqLDqQd+C2H3iwCqV+9KZfg@mail.gmail.com>
Subject: Re: [PATCH] media: use unsigned for pad index
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Nicholas Mc Guire <der.herr@hofr.at>,
	OSUOSL Drivers <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 11, 2015 at 2:26 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> The pad index is unsigned. Replace the occurences of it where
> pertinent.
>
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 2 +-
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    | 2 +-
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 2 +-

For the above:

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
