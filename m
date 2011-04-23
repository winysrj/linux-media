Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36991 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1DWFG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 01:06:59 -0400
Received: by iyb14 with SMTP id 14so833414iyb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2011 22:06:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com>
References: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com>
Date: Fri, 22 Apr 2011 23:06:58 -0600
Message-ID: <BANLkTi=y6_86zX_Sz69oPhMOJg_duTrcGQ@mail.gmail.com>
Subject: Re: Regression with suspend from "msp3400: convert to the new control framework"
From: Jesse Allen <the3dfxdude@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Apr 22, 2011 at 3:55 PM, Jesse Allen <the3dfxdude@gmail.com> wrote:
> Hello All,
>
> I have finally spent time to figure out what happened to suspending
> with my bttv card. I have traced it to this patch:
>
> msp3400: convert to the new control framework
> ebc3bba5833e7021336f09767347a52448a60bc5
>
> This was done by reverting the patch at the head for v2.6.39-git.
>

I may be still wrong about this patch being the problem. I will have
to keep hunting for the real answer.

Jesse
