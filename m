Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:33169 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755283AbdD1RWd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 13:22:33 -0400
Date: Fri, 28 Apr 2017 19:22:31 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Subject: Re: [PATCH] ir-lirc-codec: let lirc_dev handle the lirc_buffer
Message-ID: <20170428172231.xel6itzfutdeh53w@hardeman.nu>
References: <149339904926.12280.15877468271781678130.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149339904926.12280.15877468271781678130.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 28, 2017 at 07:04:09PM +0200, David Härdeman wrote:
>ir_lirc_register() currently creates its own lirc_buffer before
>passing the lirc_driver to lirc_register_driver().
>
>When a module is later unloaded, ir_lirc_unregister() gets called
>which performs a call to lirc_unregister_driver() and then free():s
>the lirc_buffer.
>
>The problem is that:
>
>a) there can still be a userspace app holding an open lirc fd
>   when lirc_unregister_driver() returns; and
>
>b) the lirc_buffer contains "wait_queue_head_t wait_poll" which
>   is potentially used as long as any userspace app is still around.
>
>The result is an oops which can be triggered quite easily by a
>userspace app monitoring its lirc fd using epoll() and not closing
>the fd promptly on device removal.
>
>The minimalistic fix is to let lirc_dev create the lirc_buffer since
>lirc_dev will then also free the buffer once it believes it is safe to
>do so.
>
>I'm pretty certain that any driver which creates its own lirc_buffer
>is quite likely to be buggy as well, but that seems to only concern
>staging.
>
>Signed-off-by: David Härdeman <david@hardeman.nu>

And there should probably be a CC: stable@vger.kernel.org here...

>---
> drivers/media/rc/ir-lirc-codec.c |   23 +++++------------------
> 1 file changed, 5 insertions(+), 18 deletions(-)
