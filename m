Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51230 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945905Ab2KNWxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 17:53:10 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so630328iay.19
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 14:53:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121113145809.GA15029@kroah.com>
References: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com>
	<20121113145809.GA15029@kroah.com>
Date: Wed, 14 Nov 2012 19:53:10 -0300
Message-ID: <CALF0-+Xt4bEgXHYV3-4pX4q95yJONsOQvg3wKhKvO-g5mdV8Lw@mail.gmail.com>
Subject: Re: Regarding bulk transfers on stk1160
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	michael hartup <michael.hartup@gmail.com>,
	linux-rpi-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Tue, Nov 13, 2012 at 11:58 AM, Greg KH <greg@kroah.com> wrote:
>
> Or better yet, buy a board with a working USB port, like a BeagleBone or
> the like :)
>

Michael Hartup (the interested user) *has* a beaglebone.

I'm trying to help him getting it ready for stk1160.
However, Michael is getting choppy video capture.
(dmesg doesn't show anything relevant)

@Michael, could you upload those captures somewhere
and post the links for everyone to see?

Is this related to beaglebone's known usb dma issues?

https://github.com/RobertCNelson/linux-dev/issues/2
https://groups.google.com/forum/?fromgroups=#!topic/beagleboard/J94PUlo0wzs

Unfortunately, I don't own a beaglebone (and I can't afford one right now)
so I can't really see for myself what's going on.

Any help, greatly appreciated.

    Ezequiel
