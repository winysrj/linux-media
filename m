Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:33169 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbZJDQZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 12:25:37 -0400
Received: by ewy7 with SMTP id 7so2823715ewy.17
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 09:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AC8C227.4000301@redhat.com>
References: <4AC8C227.4000301@redhat.com>
Date: Sun, 4 Oct 2009 18:24:59 +0200
Message-ID: <62e5edd40910040924g38d42351le2642849cdd2cf5b@mail.gmail.com>
Subject: Re: PATCH: gscpa stv06xx + ov518: dont discard every other frame
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean-Francois Moine <moinejf@free.fr>,
	James Blanford <jhblanford@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/10/4 Hans de Goede <hdegoede@redhat.com>:
> Hi,
>
> As noticed by James Blanford <jhblanford@gmail.com>, we were discarding
> every other frame in stv06xx and the ov518 (part of ov519.c) drivers.
>
> When we call gspca_frame_add, it returns a pointer to the frame passed in,
> unless we call it with LAST_PACKET, when it will return a pointer to a
> new frame in which to store the frame data for the next frame. So whenever
> calling:
> gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);
> we should do this as:
> frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, data, len);
>
> So that any further data got from of the pkt we are handling in pkt_scan,
> goes
> to the next frame.
>
> We are not doing this in stv06xx.c pkt_scan method, which the cause of what
> James is seeing. So I started checking all drivers, and we are not doing
> this
> either in ov519.c when handling an ov518 bridge. So now the framerate of my
> 3 ov518 test cams has just doubled. Thanks James!
>
What a great discovery!  \o/

Regards,
Erik

> The attached patch fixes this.
>
> Regards,
>
> Hans
>
