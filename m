Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46889 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2HEVvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Aug 2012 17:51:46 -0400
Received: by obbuo13 with SMTP id uo13so4819976obb.19
        for <linux-media@vger.kernel.org>; Sun, 05 Aug 2012 14:51:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344199202-15744-1-git-send-email-develkernel412222@gmail.com>
References: <1344199202-15744-1-git-send-email-develkernel412222@gmail.com>
Date: Sun, 5 Aug 2012 18:51:45 -0300
Message-ID: <CALF0-+UHQ_TdAL-wdRLEjoi33UiFBVMUCZLbaMh9oZ5qsDOA_A@mail.gmail.com>
Subject: Re: [PATCH] staging: media: cxd2099: remove memcpy of similar
 structure variables
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Devendra Naga <develkernel412222@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devendra,

Thanks for the patch,

On Sun, Aug 5, 2012 at 5:40 PM, Devendra Naga
<develkernel412222@gmail.com> wrote:
> structure variables can be assigned, no memcpy needed,
> remove the memcpy and use assignment for the cfg and en variables.
>
> Tested by Compilation Only
>
> Suggested-by: Ezequiel Garcia <elezegarcia@gmail.com>

I'm not sure this is completely valid or useful.

If you read Documentation/SubmittingPatches (which you should)
you will find references to Acked-by, Reported-by, Tested-by,
but not this one.

You don't need to give me credit for the patch:
it's *your* patch, all I did was a very simple suggestion :-)

Plus, there was some discussion called "Kernel Komedians" [1] where
some developer expressed their concern on the number of weird signatures
that have recently appeared.

Regards,
Ezequiel.

[1] http://lwn.net/Articles/503829/
