Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47360 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab2EXQdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 12:33:39 -0400
Received: by ghrr11 with SMTP id r11so1951274ghr.19
        for <linux-media@vger.kernel.org>; Thu, 24 May 2012 09:33:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FBE5518.5090705@redhat.com>
References: <4FBE5518.5090705@redhat.com>
Date: Thu, 24 May 2012 13:33:38 -0300
Message-ID: <CALF0-+WqCmx0NMRZWr0D9gan4cF-J-Kf-5k_nTXKjFMYmBSt=A@mail.gmail.com>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thu, May 24, 2012 at 12:34 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Ezequiel Garcia (2):
>      [media] em28xx: Make card_setup() and pre_card_setup() static
>      [media] em28xx: Remove unused list_head struct for queued buffers
>
> Ezequiel García (19):
>      [media] em28xx: Remove redundant dev->ctl_input set
>      [media] em28xx: Export em28xx_[read,write]_reg functions as SYMBOL_GPL

Looks like I have a clone ;)

I wasn't sure how to handle the accentuated "i" in García.
Perhaps this change obeys the fact in some point, I changed the way
gmail sends my name.
I have always signed-off as Garcia (non accentuated), despite being wrong.

It's not really important, right?
