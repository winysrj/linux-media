Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:53715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1EIUHU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 16:07:20 -0400
Message-ID: <4DC8497F.9030002@redhat.com>
Date: Mon, 09 May 2011 16:07:27 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: =?UTF-8?B?SnVhbiBKZXPDunMgR2FyY8OtYSBkZSBTb3JpYQ==?=
	<skandalfo@gmail.com>
Subject: Re: [PATCH] [media] ite-cir: finish tx before suspending
References: <4DC84470.7060603@redhat.com> <1304971156-26650-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1304971156-26650-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Jarod Wilson wrote:
> Continuing with IR transmit after resuming from suspend seems fairly
> useless, given that the only place we can actually end up suspending is
> after IR has been send and we're simply mdelay'ing. Lets simplify the
> resume path by just waiting on tx to complete in the suspend path, then
> we know we can't be transmitting on resume, and reinitialization of the
> hardware registers becomes more straight-forward.
>
> CC: Juan Jesús García de Soria<skandalfo@gmail.com>
> Signed-off-by: Jarod Wilson<jarod@redhat.com>
> ---
> Nb: this patch relies upon my earlier patch to add the init_hardware
> calls to the resume path in the first place.

Also note: I don't have tx-capable hardware (or at least, there's no
tx hardware wired up), so I haven't actually tested this, but the code 
added to ite_suspend is more or less cloned from ite_close.

-- 
Jarod Wilson
jarod@redhat.com


