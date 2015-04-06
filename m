Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38659 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbbDFQEI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2015 12:04:08 -0400
Received: by wiun10 with SMTP id n10so39369222wiu.1
        for <linux-media@vger.kernel.org>; Mon, 06 Apr 2015 09:04:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK-SLvBcZG5VN4BkUV+jS0z_xqXpVwJFMXfMaQF7kfFxJ7En9A@mail.gmail.com>
References: <CAK-SLvBcZG5VN4BkUV+jS0z_xqXpVwJFMXfMaQF7kfFxJ7En9A@mail.gmail.com>
Date: Mon, 6 Apr 2015 18:04:07 +0200
Message-ID: <CAK-SLvCyQT6cEpfCxaUMrT7f_5dasnAEDr1PGrW3BpS+KXRkKw@mail.gmail.com>
Subject: Re: using TSOP receiver without lircd
From: Sergio Serrano <sergio.badalona@gmail.com>
To: linux-media@vger.kernel.org
Cc: david@hardeman.nu
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi members!

In the hope that someone can help me, I has come to this mailing list
after contacting David Hardeman (thank you!).
He has already given me some clues. This is my scenario.

I'm using a OMAP2 processor and capturing TSOP34836 (remote RC5
compatible) signals through GPIO+interrupt. I have created the
/dev/lirc0 device , here comes my question: If possible I don't want
to deal with LIRC and irrecord stuff. Is it possible? What will be the
first steps?

Kind regards,
Sergio
