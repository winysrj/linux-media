Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34700 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbcBKN3D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 08:29:03 -0500
Received: by mail-ig0-f176.google.com with SMTP id ik10so10467593igb.1
        for <linux-media@vger.kernel.org>; Thu, 11 Feb 2016 05:29:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87749d1653e4cf3af1c009e9b16c476957382325.1455196043.git.mchehab@osg.samsung.com>
References: <87749d1653e4cf3af1c009e9b16c476957382325.1455196043.git.mchehab@osg.samsung.com>
Date: Thu, 11 Feb 2016 10:29:01 -0300
Message-ID: <CABxcv==OGX7h9Bv=0bGv5kzKzBh3r8YXpJBMdy7xRHX+JudDzw@mail.gmail.com>
Subject: Re: [PATCH] em28xx-cards: fix compilation breakage caused by cs 622f9260802e
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On Thu, Feb 11, 2016 at 10:07 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> changeset 622f9260802e ("tvp5150: move input definition header to
> dt-bindings") broke compilation of em28xx, as it moved one header
> file used there.
>

Sigh, sorry for missing that the header was used in that driver too...

> Fix it by pointing to the newer file location.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Thanks a lot for fixing this.

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
Javier
