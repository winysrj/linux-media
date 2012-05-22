Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56011 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2EVOIv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 10:08:51 -0400
Received: by yenm10 with SMTP id m10so5392655yen.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 07:08:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120522110018.GX1927@vicerveza.homeunix.net>
References: <20120522110018.GX1927@vicerveza.homeunix.net>
From: Paulo Assis <pj.assis@gmail.com>
Date: Tue, 22 May 2012 15:08:31 +0100
Message-ID: <CAPueXH6uN4UQO_WL_pc9wBoZV=v_7AVtQKcruKY=BCMeJOw-2Q@mail.gmail.com>
Subject: Re: Problems with the gspca_ov519 driver
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: hdegoede@redhat.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This bug also causes the camera to crash when changing fps in
guvcview, uvc devices (at least all the ones I tested) require the
stream to be restarted for fps to change, so in the case of this
driver after STREAMOFF the camera just becomes unresponsive.

Regards,
Paulo

2012/5/22 Lluís Batlle i Rossell <viric@viric.name>:
> Hello,
>
> I'm trying to get video using v4l2 ioctls from a gspca_ov519 camera, and after
> STREAMOFF all buffers are still flagged as QUEUED, and QBUF fails.  DQBUF also
> fails (blocking for a 3 sec timeout), after streamoff. So I'm stuck, after
> STREAMOFF, unable to get pictures coming in again. (Linux 3.3.5).
>
> As an additional note, pinchartl on irc #v4l says to favour a moving of gspca to
> vb2. I don't know what it means.
>
> Can someone take care of the bug, or should I consider the camera 'non working'
> in linux?
>
> Thank you,
> Lluís.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
