Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63606 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab0KBP5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 11:57:24 -0400
Received: by wwe15 with SMTP id 15so7539034wwe.1
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 08:57:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101029190802.11982.96234.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
	<20101029190802.11982.96234.stgit@localhost.localdomain>
Date: Tue, 2 Nov 2010 11:57:23 -0400
Message-ID: <AANLkTim=JmHxP-DTgr3sXSmkng1RDU=aMU0Dbe9b+09+@mail.gmail.com>
Subject: Re: [PATCH 2/7] ir-core: convert drivers/media/video/cx88 to ir-core
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 3:08 PM, David Härdeman <david@hardeman.nu> wrote:
> This patch converts the cx88 driver (for sampling hw) to use the
> decoders provided by ir-core instead of the separate ones provided
> by ir-functions (and gets rid of those).
>
> The value for MO_DDS_IO had a comment saying it corresponded to
> a 4kHz samplerate. That comment was unfortunately misleading. The
> actual samplerate was something like 3250Hz.
>
> The current value has been derived by analyzing the elapsed time
> between interrupts for different values (knowing that each interrupt
> corresponds to 32 samples).
>
> Thanks to Mariusz Bialonczyk <manio@skyboo.net> for testing my patches
> (about one a day for two weeks!) on actual hardware.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
