Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34776 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756551AbcJRQci (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 12:32:38 -0400
Received: by mail-wm0-f65.google.com with SMTP id d199so242436wmd.1
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2016 09:32:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4974ed297d393d69122e2409c9697d8ec623e738.1476475771.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com> <4974ed297d393d69122e2409c9697d8ec623e738.1476475771.git.mchehab@s-opensource.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 18 Oct 2016 17:32:01 +0100
Message-ID: <CA+V-a8vhSjeAjNAn60hKq7Vy7F26_FMnDmO5ZHo2UeLADMzekA@mail.gmail.com>
Subject: Re: [PATCH 22/57] [media] davinci: don't break long lines
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Fri, Oct 14, 2016 at 9:20 PM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
