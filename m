Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56001 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3EMKlr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 06:41:47 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so6371555wgh.24
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 03:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368439554.1350.49.camel@x61.thuisdomein>
References: <1363079692-16683-1-git-send-email-nsekhar@ti.com>
 <1368438071.1350.43.camel@x61.thuisdomein> <CA+V-a8sEMsQENPN+40bMtOpTs5Xq9HbtiR49shhd=+kXU3-2YA@mail.gmail.com>
 <1368439554.1350.49.camel@x61.thuisdomein>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 13 May 2013 16:11:26 +0530
Message-ID: <CA+V-a8vOJocJttwQBnNA-sn2qWtAvgzQ96OGNbJ8NvVV_tt7uA@mail.gmail.com>
Subject: Re: [v3] media: davinci: kconfig: fix incorrect selects
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Mon, May 13, 2013 at 3:35 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Prabhakar,
>
> On Mon, 2013-05-13 at 15:27 +0530, Prabhakar Lad wrote:
>> Good catch! the dependency can be dropped now.
>
> Great.
>
>> Are you planning to post a patch for it or shall I do it ?
>
> I don't mind submitting that trivial patch.
>
> However, it's probably better if you do that. I can only state that this
> dependency is now useless, because that is simply how the kconfig system
> works. But you can probably elaborate why it's OK to not replace it with
> another (negative) dependency. That would make a more informative commit
> explanation.
>
Posted the patch fixing it https://patchwork.linuxtv.org/patch/18395/

Regards,
--Prabhakar Lad
