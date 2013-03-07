Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60754 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3CGLkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 06:40:12 -0500
Received: by mail-wi0-f181.google.com with SMTP id hm6so204100wib.2
        for <linux-media@vger.kernel.org>; Thu, 07 Mar 2013 03:40:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <513878EC.1020907@ti.com>
References: <1362492801-13202-1-git-send-email-nsekhar@ti.com>
 <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com>
 <51371553.5030103@ti.com> <CA+V-a8uRWQxcBSoTkuDAqzzCyR2e20JHEWzVuS39389QEoPazg@mail.gmail.com>
 <5137191F.6050707@ti.com> <CA+V-a8s_x_X_GdQ0aa36e-B3DhxpXJ5vzsce0yqPcn78g81m+w@mail.gmail.com>
 <513750ED.2040701@ti.com> <CA+V-a8vaT4d52goryzrF5YdeXBVvCzfGnVicaNMuYL85Lmabcg@mail.gmail.com>
 <513878EC.1020907@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 7 Mar 2013 17:09:49 +0530
Message-ID: <CA+V-a8sMTqU4PkxZ8_EK5yNY1S22G2G=7-bs5j31Umi_Dt97gQ@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sekhar,

On Thu, Mar 7, 2013 at 4:54 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 3/7/2013 12:47 PM, Prabhakar Lad wrote:
>
>> On Wed, Mar 6, 2013 at 7:51 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>> So instead of presenting a non-useful vpif selection to users,
>>> vpif.c dependency is better handled in makefile, no?
>>>
>> Agreed that’s a better fix.
>
> How about VIDEO_VPFE_CAPTURE? Does enabling just that config present any
> interface which can be used? Or should vpfe_capture.c be automatically
> built as well?
>
Yes this can be removed as well and handle in Makefile. And for consistency
you can rename VIDEO_ISIF to VIDEO_DM365_ISIF.

Regards,
--Prabhakar

> Thanks,
> Sekhar
