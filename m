Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:51860 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaGUNbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 09:31:03 -0400
Message-ID: <1405949458.2258.4.camel@mpb-nicolas>
Subject: Re: [RFC PATCH] Docbook/media: improve data_offset/bytesused
 documentation
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Date: Mon, 21 Jul 2014 09:30:58 -0400
In-Reply-To: <53CD12BF.9050202@xs4all.nl>
References: <53CD12BF.9050202@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le lundi 21 juillet 2014 à 15:16 +0200, Hans Verkuil a écrit :
> +             Note that data_offset is included in <structfield>bytesused</structfield>.
> +             So the size of the image in the plane is
> +             <structfield>bytesused</structfield>-<structfield>data_offset</structfield> at
> +             offset <structfield>data_offset</structfield> from the start of the plane.

This seem like messing applications a lot. Let's say you have a well
known format, NV12, but your driver add some customer header at the
beginning. Pretty much all the application in the world would work just
fine ignoring that header, but in fact most of them will not work,
because bytesused is including the header. Considering this wasn't
documented before, I would strongly suggest to keep the bytesused as
being the size for the format know by everyone.


