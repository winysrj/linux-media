Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:52413 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752054AbcLXLCf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 06:02:35 -0500
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: =?UTF-8?Q?[media]_tm6000:_Addition_of_an_asterisk_to_the_data_type_?=
 =?UTF-8?B?Zm9yIOKAnHVyYl9kbWHigJ0/?=
Message-ID: <b0c2e4b7-5c04-afd8-dc0f-a66c1bd47308@users.sourceforge.net>
Date: Sat, 24 Dec 2016 12:02:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have looked at the implementation of the function “tm6000_alloc_urb_buffers”
once more.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/usb/tm6000/tm6000-video.c?id=84ede50b623fb45c4c026c80d0abf8cc5193f041#n469

A pointer for an array is also assigned to the member “urb_dma” of the data
structure “tm6000_core” there. I would interpret the corresponding data type
specification in the way that only a single element should be managed by
this field so far.
http://lxr.free-electrons.com/source/drivers/media/usb/tm6000/tm6000.h?v=4.9#L271

How do you think about to add another asterisk to this data type specification
so that the desired array management would become bit clearer for such a field
(similar to the member “urb_buffer”)?

Regards,
Markus
