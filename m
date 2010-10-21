Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39607 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab0JUPXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 11:23:21 -0400
Received: by gxk3 with SMTP id 3so106956gxk.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 08:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101021120746.01ca4ef2@pedra>
References: <cover.1287669886.git.mchehab@redhat.com>
	<20101021120746.01ca4ef2@pedra>
Date: Thu, 21 Oct 2010 11:23:20 -0400
Message-ID: <AANLkTikT8aLi7uTc6-wGwcJsoL64y7Wv3iLcUetx642R@mail.gmail.com>
Subject: Re: [PATCH 2/4] [media] ir-raw-event: Fix a stupid error at a printk
From: Jarod Wilson <jarod@wilsonet.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Oct 21, 2010 at 10:07 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>
> diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
> index 0d59ef7..a06a07e 100644
> --- a/drivers/media/IR/ir-raw-event.c
> +++ b/drivers/media/IR/ir-raw-event.c
> @@ -89,7 +89,7 @@ int ir_raw_event_store(struct input_dev *input_dev, struct ir_raw_event *ev)
>        if (!ir->raw)
>                return -EINVAL;
>
> -       IR_dprintk(2, "sample: (05%dus %s)\n",
> +       IR_dprintk(2, "sample: (%05dus %s)\n",
>                TO_US(ev->duration), TO_STR(ev->pulse));
>
>        if (kfifo_in(&ir->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))


Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
