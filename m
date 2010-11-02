Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65155 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab0KBP7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 11:59:55 -0400
Received: by wyf28 with SMTP id 28so6858059wyf.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 08:59:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101029190812.11982.9884.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
	<20101029190812.11982.9884.stgit@localhost.localdomain>
Date: Tue, 2 Nov 2010 11:59:54 -0400
Message-ID: <AANLkTikRpyr9aG8B+tzm9hya1rZrv6QWuwsvAB-7Dpk1@mail.gmail.com>
Subject: Re: [PATCH 4/7] ir-core: more cleanups of ir-functions.c
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 3:08 PM, David Härdeman <david@hardeman.nu> wrote:
> cx88 only depends on VIDEO_IR because it needs ir_extract_bits().
> Move that function to ir-core.h and make it inline.
>
> Lots of drivers had dependencies on VIDEO_IR when they really
> wanted IR_CORE.
>
> The only remaining drivers to depend on VIDEO_IR are bt8xx and
> saa7134 (ir_rc5_timer_end is the only function exported by
> ir-functions).
>
> Rename VIDEO_IR -> IR_LEGACY to give a hint to anyone writing or
> converting drivers to IR_CORE that they do not want a dependency
> on IR_LEGACY.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
