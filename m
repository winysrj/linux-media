Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46112 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab3LOSDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Dec 2013 13:03:09 -0500
Received: by mail-bk0-f42.google.com with SMTP id w11so2067623bkz.1
        for <linux-media@vger.kernel.org>; Sun, 15 Dec 2013 10:03:07 -0800 (PST)
Message-ID: <52ADEED9.1060407@googlemail.com>
Date: Sun, 15 Dec 2013 19:03:05 +0100
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: libdvbv5: dvb_table_pat_init is leaking memory
References: <CAJxGH09uZhZ0m4GcpAF4moURp18hPmBh5cOP_ZHoNxAaadL_XQ@mail.gmail.com> <20131127203121.78baf121@infradead.org> <20131127204642.05ddaac5@samsung.com> <20131128102410.45bbe3a2@samsung.com>
In-Reply-To: <20131128102410.45bbe3a2@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 28/11/13 13:24, Mauro Carvalho Chehab wrote:
> After a good resting night, I reviewed it, and it turns that memory leaks
> can occur.
>
> So, I re-worked the logic. I also fixed the other bugs pointed by Coverity
> today. Could you please re-run the Coverity tests, to see if everything is
> OK with the current version?

I triggered a rebuild last night. Currently this is a manual process.

Hans, as far as I know you're automatically building the media tree and 
check for warnings. Could you also host the nightly Coverity run?
On my i7 it takes about a minute per run.

Thanks,
Gregor

