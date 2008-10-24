Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9OHZQMu003254
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 13:35:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9OHZF1F013551
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 13:35:15 -0400
Date: Fri, 24 Oct 2008 15:35:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Markus Rechberger" <mrechberger@gmail.com>
Message-ID: <20081024153509.0f51d676@pedra.chehab.org>
In-Reply-To: <d9def9db0810221359h5118b8d2pd6d2b3f4f95496ce@mail.gmail.com>
References: <d9def9db0810221359h5118b8d2pd6d2b3f4f95496ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	em28xx <em28xx@mcentral.de>
Subject: Re: [PATCH 1/7] Adding empia base driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 22 Oct 2008 22:59:00 +0200
"Markus Rechberger" <mrechberger@gmail.com> wrote:

>     em2880-dvb:
>     * supporting the digital part of Empia based devices, which
> includes ATSC, ISDB-T and DVB-T
> 
>     em28xx-aad.c:
>     * alternative audio driver, can be used instead of em28xx-audio if
> alsa is not available
>     or not compiled into the kernel, it provides a raw interface to
> the PCM samples
> 
>     em28xx-audio.c:
>     * em28xx alsa driver and audio driver for FM radio
> 
>     em28xx-audioep.c:
>     * em28xx alsa driver for devices which are set to vendor specific
> audio on interface 1,
>     in that case snd-usb-audio will not attach to the interface and
> em28xx-audioep will be needed
> 
>     em28xx-cards.c:
>     * card definition and initial setup of devices.
> 
>     em28xx-core.c:
>     * core videohandling and VBI frame slicing
> 
>     em28xx-i2c.c:
>     * i2c setup and GPIO setup handling of the devices (including
> em2888 based ones)
> 
>     em28xx-input.c:
>     * currently mostly disabled since the linuxtv input handling is
> broken by design and racy
> 
>     em28xx-keymaps.c:
>     * keymap references of some remotes (could be merged into
> ir-common, although as mentioned
>     this should be in userland done by lirc).
> 
>     em28xx-video.c:
>     * inode handling for analog TV, radio and VBI, also some device probing
> 
>     em28xx-webcam.c:
>     * videology webcam specific i2c commands

NACK.

There's already a driver for em28xx. Be welcome sending incremental patches to
improve, like other developers do. But another driver for the same chip would
just create a mess.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
