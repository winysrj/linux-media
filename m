Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47626 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2CNLWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 07:22:44 -0400
Received: by iagz16 with SMTP id z16so2195775iag.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 04:22:44 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 14 Mar 2012 12:22:43 +0100
Message-ID: <CACKLOr3T-w1JdaGgnL+ZEXFX4v_oVd0HY8mqrm5ZzxEziH32jw@mail.gmail.com>
Subject: [Q] media: V4L2 compressed frames and s_fmt.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm developing a V4L2 mem2mem driver for the codadx6 IP video codec
which is included in the i.MX27 chip.

The capture interface of this driver can therefore return h.264 or
mpeg4 video frames.

Provided that the size of each frame varies and is unknown to the
user, how is the driver supposed to react to a S_FMT when it comes to
parameters such as the following?

pix->width
pix->height
pix->bytesperline
pix->sizeimage

According to the documentation [1] I understand that the driver can
just ignore 'bytesperline' and should return in 'sizeimage' the
maximum buffer size to store a compressed frame. However, it does not
mention anything special about width and height. Does it make sense
setting width and height for h.264/mpeg4 formats?


[1] http://v4l2spec.bytesex.org/spec/c2030.htm#V4L2-PIX-FORMAT
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
