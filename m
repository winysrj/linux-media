Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37251 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab2GSSlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 14:41:20 -0400
Received: by qcro28 with SMTP id o28so1923336qcr.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 11:41:19 -0700 (PDT)
Date: Thu, 19 Jul 2012 15:41:11 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by
 reworking module parameter
Message-ID: <20120719154111.2e4296b9@pirotess>
In-Reply-To: <CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
	<1340308332-1118-10-git-send-email-elezegarcia@gmail.com>
	<CADThq4+29av-MeYZR8KfBiBQkFPx+OpWhe40Kk+WX1yUD=4dOA@mail.gmail.com>
	<CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Jul 2012 10:25:09 -0300
Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno
> <ismael.luceno@gmail.com> wrote:
> > On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia
> > <elezegarcia@gmail.com> wrote:
> >> This patch moves video_nr module parameter to core.c
> >> and then passes that parameter as an argument to functions
> >> that need it.
> >> This way we avoid the extern declaration and parameter
> >> dependencies are better exposed.
> > <...>
> >
> > NACK.
> >
> > The changes to video_nr are supposed to be preserved.
> 
> Mmm, I'm sorry but I don't see any functionality change in this patch,
> just a cleanup.
> 
> What do you mean by "changes to video_nr are supposed to be
> preserved"?

It is modified by solo_enc_alloc, which is called multiple times by
solo_enc_v4l2_init.
