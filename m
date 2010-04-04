Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:38363 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab0DDDOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Apr 2010 23:14:19 -0400
Received: by fxm27 with SMTP id 27so256522fxm.28
        for <linux-media@vger.kernel.org>; Sat, 03 Apr 2010 20:14:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net>
References: <32832848.1270295705043.JavaMail.ngmail@webmail10.arcor-online.net>
Date: Sat, 3 Apr 2010 23:14:17 -0400
Message-ID: <x2r30353c3d1004032014qc2b31bd5uab4da9a0d364e8ff@mail.gmail.com>
Subject: Re: Re: [RFC] Serialization flag example
From: David Ellingsworth <david@identd.dyndns.org>
To: hermann-pitton@arcor.de
Cc: awalls@md.metrocast.net, mchehab@redhat.com,
	dheitmueller@kernellabs.com, abraham.manu@gmail.com,
	hverkuil@xs4all.nl, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After looking at the proposed solution, I personally find the
suggestion for a serialization flag to be quite ridiculous. As others
have mentioned, the mere presence of the flag means that driver
writers will gloss over any concurrency issues that might exist in
their driver on the mere assumption that specifying the serialization
flag will handle it all for them.

As the author of the most recent patches to radio-mr800, the proposed
changes not only add additional complexity to the driver but also
remove some of the fundamental error checking within the driver.
Despite the fact the error check might not always be successful, it
will still catch the majority of cases. I therefore NACK the proposed
patches to this driver.

The right thing to do is to actually correct the issue within all the
drivers that need it. Is this a lot of work? Maybe, but it's a far
better solution as each driver will be responsible for concurrency
issues that it may or may not have. After all, wasn't this what the
removal of the BKL was about in the first place?

Regards,

David Ellingsworth
