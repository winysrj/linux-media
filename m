Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46814 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0KBP7R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 11:59:17 -0400
Received: by wyf28 with SMTP id 28so6857549wyf.19
        for <linux-media@vger.kernel.org>; Tue, 02 Nov 2010 08:59:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101029190807.11982.32323.stgit@localhost.localdomain>
References: <20101029190745.11982.75723.stgit@localhost.localdomain>
	<20101029190807.11982.32323.stgit@localhost.localdomain>
Date: Tue, 2 Nov 2010 11:59:14 -0400
Message-ID: <AANLkTinykpMSJk+UOj8=975BPDMRAOb3tUOOY3phgPxn@mail.gmail.com>
Subject: Re: [PATCH 3/7] ir-core: remove remaining users of the ir-functions keyhandlers
From: Jarod Wilson <jarod@wilsonet.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, Oct 29, 2010 at 3:08 PM, David Härdeman <david@hardeman.nu> wrote:
> This patch removes the remaining usages of the ir_input_nokey() and
> ir_input_keydown() functions provided by drivers/media/IR/ir-functions.c
> by using the corresponding functionality in ir-core instead.
>
> Signed-off-by: David Härdeman <david@hardeman.nu>

Acked-by: Jarod Wilson <jarod@redhat.com>

Also tested the imon bits, at least as part of the whole series.

-- 
Jarod Wilson
jarod@wilsonet.com
