Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53846 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759108Ab0EDNyj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 09:54:39 -0400
Received: by wye20 with SMTP id 20so2366267wye.19
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 06:54:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100504113733.GU29093@bicker>
References: <20100504113733.GU29093@bicker>
Date: Tue, 4 May 2010 09:54:36 -0400
Message-ID: <u2gbe3a4a1005040654w376ebafeh74470aeb830f3450@mail.gmail.com>
Subject: Re: [patch -next 1/3] media/IR/imon: precendence issue: ! vs ==
From: Jarod Wilson <jarod@wilsonet.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 4, 2010 at 7:37 AM, Dan Carpenter <error27@gmail.com> wrote:
> The original condition is always false because ! has higher precedence
> than == and neither 0 nor 1 is equal to IMON_DISPLAY_TYPE_VGA.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
