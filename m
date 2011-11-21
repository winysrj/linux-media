Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35913 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1KUW4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 17:56:46 -0500
Received: by ggnr5 with SMTP id r5so2894198ggn.19
        for <linux-media@vger.kernel.org>; Mon, 21 Nov 2011 14:56:45 -0800 (PST)
Date: Mon, 21 Nov 2011 20:02:17 -0300
From: Ezequiel <elezegarcia@gmail.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, moinejf@free.fr,
	ospite@studenti.unina.it
Subject: Re: [PATCH v2] [media] gspca: replaced static allocation by
 video_device_alloc/video_device_release
Message-ID: <20111121230217.GA2569@devel2>
References: <20111119214621.GA2739@localhost>
 <4EC8D069.1080204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC8D069.1080204@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 20, 2011 at 11:03:21AM +0100, Hans de Goede wrote:
> NACK again! There is no reason to do this, it just makes
> the code more complicated without gaining anything. As already
> commented by Antonio Ospite your commit message lacks the why of
> this patch / the reason to do such a patch. The diffstat clearly
> shows it is adding code not removing / simplifying it and it
> so doing so without any good reasons!
> 
Yes, it's true: I omit the the reason in the commit message.
The point of the patch was improving readability of the code.

But it was altogether wrong, as Jean-Francois patiently
explained to me in another thread. 

Thanks to you too for the patience,
Ezequiel.
