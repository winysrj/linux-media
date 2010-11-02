Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61720 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0KBQCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 12:02:01 -0400
Received: by wyf28 with SMTP id 28so6859892wyf.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 09:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101029190817.11982.54193.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
	<20101029190817.11982.54193.stgit@localhost.localdomain>
Date: Tue, 2 Nov 2010 12:01:59 -0400
Message-ID: <AANLkTimfeewMWqNYX+4HfGmzDeT3LtUFSxM+G4OUTSKs@mail.gmail.com>
Subject: Re: [PATCH 5/7] ir-core: merge and rename to rc-core
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 3:08 PM, David Härdeman <david@hardeman.nu> wrote:
> This patch merges the files which makes up ir-core and renames the
> resulting module to rc-core. ir-raw-event.c is still kept as a separate
> file (but renamed to rc-raw.c) as suggested by Mauro.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>


Acked-by: Jarod Wilson <jarod@redhat.com>

This also gets a...

Tested-by: Jarod Wilson <jarod@redhat.com>

...as I've tested the merged core w/mceusb, streamzap, imon and nuvoton-cir.

-- 
Jarod Wilson
jarod@wilsonet.com
