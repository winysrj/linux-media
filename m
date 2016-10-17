Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34418 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750752AbcJQGlI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 02:41:08 -0400
Received: by mail-qk0-f171.google.com with SMTP id f128so207432619qkb.1
        for <linux-media@vger.kernel.org>; Sun, 16 Oct 2016 23:41:07 -0700 (PDT)
Date: Mon, 17 Oct 2016 07:41:02 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: kernel@stlinux.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [STLinux Kernel] [PATCH 28/57] [media] c8sectpfe: don't break
 long lines
Message-ID: <20161017064102.GA8788@griffinp-ThinkPad-X1-Carbon-2nd>
References: <cover.1476475770.git.mchehab@s-opensource.com>
 <b82cb64c6328c81104143d8a509d4ab6f77873a2.1476475771.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b82cb64c6328c81104143d8a509d4ab6f77873a2.1476475771.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 14 Oct 2016, Mauro Carvalho Chehab wrote:

> Due to the 80-cols checkpatch warnings, several strings
> were broken into multiple lines. This is not considered
> a good practice anymore, as it makes harder to grep for
> strings at the source code. So, join those continuation
> lines.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 15 +++++----------

Acked-by: Peter Griffin <peter.griffin@linaro.org>

