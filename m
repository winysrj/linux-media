Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43827 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab0IHOoX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 10:44:23 -0400
MIME-Version: 1.0
In-Reply-To: <1283808373-27876-4-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	<1283808373-27876-4-git-send-email-maximlevitsky@gmail.com>
Date: Wed, 8 Sep 2010 10:44:21 -0400
Message-ID: <AANLkTik+O4Lgmk85fUXtT1mvwp-XmkPvme3uuYt7BwkO@mail.gmail.com>
Subject: Re: [PATCH 3/8] IR: fix duty cycle capability
From: Jarod Wilson <jarod@wilsonet.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Due to typo lirc bridge enabled wrong capability.
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ir-lirc-codec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
