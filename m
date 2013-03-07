Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56092 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3CGLYq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 06:24:46 -0500
Message-ID: <513878EC.1020907@ti.com>
Date: Thu, 7 Mar 2013 16:54:28 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Prabhakar Lad <prabhakar.lad@ti.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
References: <1362492801-13202-1-git-send-email-nsekhar@ti.com> <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com> <51371553.5030103@ti.com> <CA+V-a8uRWQxcBSoTkuDAqzzCyR2e20JHEWzVuS39389QEoPazg@mail.gmail.com> <5137191F.6050707@ti.com> <CA+V-a8s_x_X_GdQ0aa36e-B3DhxpXJ5vzsce0yqPcn78g81m+w@mail.gmail.com> <513750ED.2040701@ti.com> <CA+V-a8vaT4d52goryzrF5YdeXBVvCzfGnVicaNMuYL85Lmabcg@mail.gmail.com>
In-Reply-To: <CA+V-a8vaT4d52goryzrF5YdeXBVvCzfGnVicaNMuYL85Lmabcg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/7/2013 12:47 PM, Prabhakar Lad wrote:

> On Wed, Mar 6, 2013 at 7:51 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> So instead of presenting a non-useful vpif selection to users,
>> vpif.c dependency is better handled in makefile, no?
>>
> Agreed that’s a better fix.

How about VIDEO_VPFE_CAPTURE? Does enabling just that config present any
interface which can be used? Or should vpfe_capture.c be automatically
built as well?

Thanks,
Sekhar
