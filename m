Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52799 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2GSNZK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 09:25:10 -0400
Received: by gglu4 with SMTP id u4so2737034ggl.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 06:25:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADThq4+29av-MeYZR8KfBiBQkFPx+OpWhe40Kk+WX1yUD=4dOA@mail.gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
	<1340308332-1118-10-git-send-email-elezegarcia@gmail.com>
	<CADThq4+29av-MeYZR8KfBiBQkFPx+OpWhe40Kk+WX1yUD=4dOA@mail.gmail.com>
Date: Thu, 19 Jul 2012 10:25:09 -0300
Message-ID: <CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com>
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by
 reworking module parameter
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno <ismael.luceno@gmail.com> wrote:
> On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> This patch moves video_nr module parameter to core.c
>> and then passes that parameter as an argument to functions
>> that need it.
>> This way we avoid the extern declaration and parameter
>> dependencies are better exposed.
> <...>
>
> NACK.
>
> The changes to video_nr are supposed to be preserved.

Mmm, I'm sorry but I don't see any functionality change in this patch,
just a cleanup.

What do you mean by "changes to video_nr are supposed to be preserved"?
