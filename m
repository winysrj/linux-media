Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1CVR6Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 13:58:16 -0400
Message-ID: <4D88E32C.2000005@redhat.com>
Date: Tue, 22 Mar 2011 14:58:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrice Chotard <patrice.chotard@sfr.fr>
CC: linux-media@vger.kernel.org,
	Theodore Kilgore <kilgota@banach.math.auburn.edu>,
	Jean-Francois Moine <moinejf@free.fr>
Subject: Re: [PATCH v2] New Jeilin dual-mode camera support
References: <4D7E98D2.3050609@sfr.fr>
In-Reply-To: <4D7E98D2.3050609@sfr.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-03-2011 19:38, Patrice Chotard escreveu:
> I have forgotten to include the Documentation/video4linux/gspca.txt modification in my previous patch
> 
> Patrice.
>
> Sportscam_DV15.patch
> 
> Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
> 	       Theodore Kilgore <kilgota@banach.math.auburn.edu>
> ---
>  Documentation/video4linux/gspca.txt |    1 +
>  drivers/media/video/gspca/jeilinj.c |  396 ++++++++++++++++++++++++++++++-----
> 2 files changed, 345 insertions(+), 52 deletions(-)

Please, don't send patches like that. It makes harder to handle. Instead, use:


<patch description>

Signed-off-by: Patrice CHOTARD <patricechotard@free.fr>
Signed-off-by: Theodore Kilgore <kilgota@banach.math.auburn.edu>

---

I have forgotten to include the Documentation/video4linux/gspca.txt modification in my previous patch
(and/or any other review comments that you might have - everything between "---" and the diff
will be discarded by usual scripts).

>  Documentation/video4linux/gspca.txt |    1 +
>  drivers/media/video/gspca/jeilinj.c |  396 ++++++++++++++++++++++++++++++-----
> 2 files changed, 345 insertions(+), 52 deletions(-)


-

/me is waiting for Jean-Francois final review, in order to apply it upstream.

Thanks,
Mauro
