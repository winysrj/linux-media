Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46698 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab2HVBz5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 21:55:57 -0400
Received: by wgbdr13 with SMTP id dr13so382826wgb.1
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 18:55:56 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 21 Aug 2012 22:55:56 -0300
Message-ID: <CALF0-+UMaO9ygn4P+g7XSffLjwYCkuGOXxb9gEQWhxuhHBptSQ@mail.gmail.com>
Subject: [RFC PATCH 0/1] videobuf2-core: Change vb2_queue_init return type to void
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This is a simple patch that replaces vb2_queue_init return type.
Currently vb2_queue_init is returning an integer, but it always return 0
since it's a very simple function and doesn't take any actions that can fail.

For this reason some drivers (e.g. pwc) don't bother to check the return value,
while others do.

This patch simply change this return type to void;
it's only an RFC and, of course, it won't compile as it is.

It's arguable that one may want to keep returning an integer, just in
case we consider
returning something other than 0 in the future.
On the other hand, fixing this to void will help simplify lots of drivers.

If you think the change is good, I'll prepare a nice patchset fixing
the drivers aswell.

Thanks,
Ezequiel.
