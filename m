Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34055 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab0IIElC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 00:41:02 -0400
Received: by qyk36 with SMTP id 36so5548324qyk.19
        for <linux-media@vger.kernel.org>; Wed, 08 Sep 2010 21:41:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100907215159.30935.42677.stgit@localhost.localdomain>
References: <20100907214943.30935.29895.stgit@localhost.localdomain>
	<20100907215159.30935.42677.stgit@localhost.localdomain>
Date: Thu, 9 Sep 2010 00:41:01 -0400
Message-ID: <AANLkTinQg44GcG+fbx8zhPm2+4MwsJtk8kq0PpnK7tX9@mail.gmail.com>
Subject: Re: [PATCH 4/5] rc-core: make struct rc_dev the primary interface for
 rc drivers
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	jarod@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Tue, Sep 7, 2010 at 5:51 PM, David Härdeman <david@hardeman.nu> wrote:
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

I've only looked at the core pieces of the patch and spot-checked the
drivers and decoders I'm most familiar with thus far, but I'm *very*
much in favor of this patch. The parts I've looked at are a very nice
improvement that greatly simplifies the interface, and should
eliminate multiple possible coding failure points and reduce
duplication (a few sections of imon, mceusb and streamzap all looked
pretty damned similar, this patch removes the bulk of that duplication
and abstracts it away). With the caveat that I haven't actually
functionally tested it yet, nor looked at every single bit of it:

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
