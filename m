Return-path: <linux-media-owner@vger.kernel.org>
Received: from pv33p04im-asmtp002.me.com ([17.143.181.11]:47320 "EHLO
        pv33p04im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbcIDT4E (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 15:56:04 -0400
Received: from process-dkim-sign-daemon.pv33p04im-asmtp002.me.com by
 pv33p04im-asmtp002.me.com
 (Oracle Communications Messaging Server 7.0.5.38.0 64bit (built Feb 26 2016))
 id <0OCZ00400WMQSG00@pv33p04im-asmtp002.me.com> for
 linux-media@vger.kernel.org; Sun, 04 Sep 2016 19:55:13 +0000 (GMT)
Content-type: text/plain; charset=us-ascii
MIME-version: 1.0 (1.0)
Subject: Re: uvcvideo error on second capture from USB device,
 leading to V4L2_BUF_FLAG_ERROR
From: Oliver Collyer <ovcollyer@mac.com>
In-reply-to: <20160904192538.75czuv7c2imru6ds@zver>
Date: Sun, 04 Sep 2016 22:55:07 +0300
Cc: linux-media@vger.kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <2C343957-781F-4169-BB0A-01A9F6A1EB32@mac.com>
References: <C29C248E-5D7A-4E69-A88D-7B971D42E984@mac.com>
 <20160904192538.75czuv7c2imru6ds@zver>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey

I'm already building my own FFmpeg from git master but in any case it happen=
s with the V4L2 API capture example in exactly the same way.

I have rebuilt uvcvideo/v4l from media_build with same result but I'll try l=
ater kernel.

Regards

Oliver

> On 4 Sep 2016, at 22:25, Andrey Utkin <andrey_utkin@fastmail.com> wrote:
>=20
> Hi!
> Seems like weird error in V4L subsystem or in uvcvideo driver, in the
> most standard usage scenario.
> Please retry with kernel and FFmpeg as new as possible, best if compiled
> from latest upstream sources.
> For kernel please try release 4.7.2 or even linux-next
> (git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git), for
> FFmpeg please make a git clone from git://source.ffmpeg.org/ffmpeg.git
> and there do "./configure && make" and run obtained "ffmpeg" binary.
>=20
> Please CC me when you come back with your results.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
