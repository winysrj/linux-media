Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33773 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaEVLdD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 May 2014 07:33:03 -0400
Received: by mail-ie0-f181.google.com with SMTP id rp18so1829456iec.12
        for <linux-media@vger.kernel.org>; Thu, 22 May 2014 04:33:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 May 2014 13:33:03 +0200
Message-ID: <CAHqFTYpRQ1=S8tVb5-Mgc79p_DNCecyoUnpj77zQeiiJP2Z6rA@mail.gmail.com>
Subject: V4L2 control API - choosing base CID for private controls
From: Krzysztof Czarnowski <khczarnowski@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I got completely confused while trying to create private controls with
control API and when I finally got down to sanity checks in
v4l2_ctrl_new() in v4l2-ctrls.c...

It would be nice if the following explanation by Hans (archive msg69922)
or maybe some more elaborate version could somehow make its way to
Documentation/video4linux/v4l2-controls.txt
:-)

Regards,
Krzysztof
