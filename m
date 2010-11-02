Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45353 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0KBQDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 12:03:00 -0400
Received: by wwe15 with SMTP id 15so7544574wwe.1
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 09:02:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101029190823.11982.88750.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
	<20101029190823.11982.88750.stgit@localhost.localdomain>
Date: Tue, 2 Nov 2010 12:02:58 -0400
Message-ID: <AANLkTikgo+mHtzmf7dznyGhVY-eqG0vQtA2AHK+4VwBj@mail.gmail.com>
Subject: Re: [PATCH 6/7] ir-core: make struct rc_dev the primary interface
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 3:08 PM, David Härdeman <david@hardeman.nu> wrote:
> This patch merges the ir_input_dev and ir_dev_props structs into a single
> struct called rc_dev. The drivers and various functions in rc-core used
> by the drivers are also changed to use rc_dev as the primary interface
> when dealing with rc-core.
>
> This means that the input_dev is abstracted away from the drivers which
> is necessary if we ever want to support multiple input devs per rc device.
>
> The new API is similar to what the input subsystem uses, i.e:
> rc_device_alloc()
> rc_device_free()
> rc_device_register()
> rc_device_unregister()
>
> Signed-off-by: David Härdeman <david@hardeman.nu>

Acked-by: Jarod Wilson <jarod@redhat.com>
Tested-by: Jarod Wilson <jarod@redhat.com>

Tested mceusb, streamzap, imon and nuvonton-cir.

-- 
Jarod Wilson
jarod@wilsonet.com
