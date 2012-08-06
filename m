Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55053 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2HFUHn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 16:07:43 -0400
Received: by wibhm11 with SMTP id hm11so2103141wib.1
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 13:07:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344279745-13024-1-git-send-email-mchehab@redhat.com>
References: <1344279745-13024-1-git-send-email-mchehab@redhat.com>
Date: Tue, 7 Aug 2012 01:37:42 +0530
Message-ID: <CAHFNz9Jz5x8i7-ip9BOdwC06tYR1SETctvvTpA4V=mbezhRoAw@mail.gmail.com>
Subject: Re: [PATCH] [media] mantis: merge both vp2033 and vp2040 drivers
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 7, 2012 at 12:32 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> As noticed at:
>         http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/48034
>
> Both drivers are identical, except for the name. So, there's no
> sense on keeping both. Instead of forking the entire code, just
> fork the vp3033_config struct, saving some space, and cleaning
> up the Kernel.

>
> Reported-by: Igor M. Liplianin <liplianin@me.by>
> Cc: Manu Abraham <abraham.manu@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Nack.

VP-2033 and 2040 are both different in terms of hardware. If someone
wants to add
in additional frontend characteristic differences, he shouldn't have
to add in this code
again.
