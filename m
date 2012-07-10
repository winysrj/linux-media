Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44941 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119Ab2GJP5m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 11:57:42 -0400
Received: by ghrr11 with SMTP id r11so138230ghr.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jul 2012 08:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+XSJ_Jm3YLtiFRwYH0E0XD=q7Sf78w6YYdBXtc8Wx-HoA@mail.gmail.com>
References: <CALF0-+XSJ_Jm3YLtiFRwYH0E0XD=q7Sf78w6YYdBXtc8Wx-HoA@mail.gmail.com>
Date: Tue, 10 Jul 2012 12:57:41 -0300
Message-ID: <CALF0-+USxUkeWOdUeWH62RVmkEz9-BDFcsmo_S0jEg2=UxTZrQ@mail.gmail.com>
Subject: Re: [PATCH 0/10] staging: solo6x10: General cleaning with ./scripts/checkpatch.pl
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: ismael.luceno@gmail.com
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devendra Naga <devendra.aaru@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ismael,

On Thu, Jun 21, 2012 at 4:53 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Hi Mauro,
>
> This patchset aims at cleaning most issues reported by ./scripts/checkpatch.pl.
> I'm not sure if all of them are useful, so if you feel any of the
> patches are too dumb just drop it.
>
> I'm Ccing the author Ben Collins, dispite he's no longer working for
> the device manufacturer Bluecherry.
>
> The patches are based on today's linux-next; I hope this is okey.
> As I don't own this device, I can't provide any test beyond compilation.
>
> Ezequiel Garcia (10):
>  staging: solo6x10: Avoid extern declaration by reworking module parameter
>  staging: solo6x10: Fix several over 80 character lines
>  staging: solo6x10: Declare static const array properly
>  staging: solo6x10: Merge quoted string split across lines
>  staging: solo6x10: Replace printk(KERN_WARNING with dev_warn
>  staging: solo6x10: Remove format type mismatch warning
>  staging: solo6x10: Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id
>  staging: solo6x10: Replace C++ style comment with C style
>  staging: solo6x10: Use linux/{io,uaccess}.h instead of asm/{io,uaccess}.h
>  staging: solo6x10: Fix TODO file with proper maintainer
>
>  drivers/staging/media/solo6x10/TODO       |    2 +-
>  drivers/staging/media/solo6x10/core.c     |   14 ++++++---
>  drivers/staging/media/solo6x10/gpio.c     |    2 +-
>  drivers/staging/media/solo6x10/i2c.c      |    3 +-
>  drivers/staging/media/solo6x10/p2m.c      |    8 +++---
>  drivers/staging/media/solo6x10/solo6x10.h |    6 ++--
>  drivers/staging/media/solo6x10/tw28.c     |    6 ++--
>  drivers/staging/media/solo6x10/v4l2-enc.c |   39 ++++++++++++++---------------
>  drivers/staging/media/solo6x10/v4l2.c     |   25 +++++++++---------
>  9 files changed, 54 insertions(+), 51 deletions(-)
>
> Regards,
> Ezequiel.

I'm sending you this patch set because I saw on bluecherry blog that
you're working there,
replacing Ben Collins (author of solo6x10). Please correct me if I'm wrong.

I wonder if you could review this series, test, ack or even nack them :-)
They are mostly style fixes, so there shouldn't be any problems.

Thanks,
Ezequiel.
