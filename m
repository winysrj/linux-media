Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3AUUQQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 15:16:16 -0500
Date: Mon, 21 Jan 2013 18:09:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mike Martin <mike@redtux.org.uk>
Cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-usb-it913x dissapeared kernel 3.7.2
Message-ID: <20130121180932.6f6ca48b@redhat.com>
In-Reply-To: <CAOwYNKaFPLbkJn5J5XL05+g73D1k333+JjLc1rcchFk9B599Aw@mail.gmail.com>
References: <CAOwYNKaFPLbkJn5J5XL05+g73D1k333+JjLc1rcchFk9B599Aw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Jan 2013 15:47:49 +0000
Mike Martin <mike@redtux.org.uk> escreveu:

> After updating the kernel on Fedora 18 module dvb-usb-it913x seems to
> have dissapeared.
> 
> This has meant my dvb stick ( ID 1b80:e409 Afatech IT9137FN Dual DVB-T
> [KWorld UB499-2T]) no longer works
> 
> Is this a Redhat only thing or is it upstream

See this bugzilla:
	https://bugzilla.redhat.com/show_bug.cgi?id=895460

Basically, DVB_USB_V2 wasn't selected. The kernel-3.7.2-204.fc18 should
fix this issue.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
