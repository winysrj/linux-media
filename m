Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38509 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031828Ab2COTwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 15:52:22 -0400
Received: by yhmm54 with SMTP id m54so3514051yhm.19
        for <linux-media@vger.kernel.org>; Thu, 15 Mar 2012 12:52:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F62458D.5060705@redhat.com>
References: <1331840342-9191-1-git-send-email-elezegarcia@gmail.com>
	<4F62458D.5060705@redhat.com>
Date: Thu, 15 Mar 2012 16:52:21 -0300
Message-ID: <CALF0-+V6B3qbEiZ7gf231HdWdh41pkZGGPSP+zpWn-X6tRWtPQ@mail.gmail.com>
Subject: Re: [PATCH] media: rc: Pospone ir raw decoders loading until really needed
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: jarod@redhat.com, linux-media@vger.kernel.org,
	Rui Salvaterra <rsalvaterra@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>>       if (dev->driver_type == RC_DRIVER_IR_RAW) {
>> +             /* Load raw decoders, if they aren't already */
>> +             if (dev->raw_init) {
>
> The logic here seems to be inverted. it should be, instead !dev->raw_init.

Duh! Sorry about that. I'm *way* too accustomed to test things first.
Will pay more attention in the future.

Thanks for the review. I'm resending it now.
Ezequiel.
