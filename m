Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35305 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdBXJJn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Feb 2017 04:09:43 -0500
Received: by mail-qk0-f173.google.com with SMTP id u188so13580839qkc.2
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2017 01:09:43 -0800 (PST)
MIME-Version: 1.0
From: Alexandre-Xavier L-L <axdoomer@gmail.com>
Date: Fri, 24 Feb 2017 04:09:42 -0500
Message-ID: <CAKTMqxtM8c7Nv=UQf45zida-u8dEQtHYYHzsGpsqjBn7YB6ZEw@mail.gmail.com>
Subject: How broken is the em28xx driver?
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

Is it just me or every device that I try doesn't work. Here's a list,
they all use the em28xx driver.

Ion video 2 pc
Plextor ConvertX PX-AV100U
Startech SVID2USB23

Video of the results: https://www.youtube.com/watch?v=wgQKziHupkI

I have even tried a August VGB100 which doesn't use the em28xx driver
and it doesn't work too.

I have already posted on the mailing list about these issues relating
to the interlaced signal, but it's the first time that I try with a
progressive signal. Although the results are better, I cannot qualify
it as something that is working.

Is the development of the em28xx driver still going on? I would like
to know which alternative driver that I could use or which would be
the step that I could do to fix the driver (I don't have a lot of
knowledge about it). I can even mail one of my devices to somebody who
is willing to fix the em28xx driver.

Sorry if I insulted anyone by saying that the em28xx is broken, but I
have the impression that it doesn't work and that it won't ever work
with any device because they may be too much defects that prevent it
from working correctly. It could have worked before (I have seen a
video from 2013 where it did), but maybe there were regressions and no
one noticed it broke. I can't install old git releases because they
are not compatible with newer kernels.

Regards,
Alexandre-Xavier
