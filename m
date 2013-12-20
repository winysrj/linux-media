Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4647 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3LTMx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 07:53:26 -0500
Message-ID: <52B43DB0.8020107@xs4all.nl>
Date: Fri, 20 Dec 2013 13:53:04 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hans.verkuil@cisco.com>, devel@driverdev.osuosl.org,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: davinci_vpfe: fix build error
References: <1387293923-27236-1-git-send-email-prabhakar.csengg@gmail.com> <CA+V-a8sdCuO1U3Egn62g_QivmVUEXzF4RgKbi-Ksm7JZEY-KKA@mail.gmail.com>
In-Reply-To: <CA+V-a8sdCuO1U3Egn62g_QivmVUEXzF4RgKbi-Ksm7JZEY-KKA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just made a patch myself that I added to the pull request I just posted.

You didn't CC me or CC the linux-media list when you posted your patch, so I
never saw it.

Regards,

	Hans

On 12/20/2013 01:47 PM, Prabhakar Lad wrote:
> Hi Hans,
> 
> On Tue, Dec 17, 2013 at 8:55 PM, Lad, Prabhakar
> <prabhakar.csengg@gmail.com> wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> This patch includes linux/delay.h required for msleep,
>> which fixes following build error.
>>
>> dm365_isif.c: In function ‘isif_enable’:
>> dm365_isif.c:129:2: error: implicit declaration of function ‘msleep’
>>
> Will you pick this patch or shall I go ahead and  issue a pull to Mauro ?
> 
> Regards,
> --Prabhakar Lad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
