Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53002 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2GSUnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 16:43:07 -0400
Received: by gglu4 with SMTP id u4so3269007ggl.19
        for <linux-media@vger.kernel.org>; Thu, 19 Jul 2012 13:43:06 -0700 (PDT)
Date: Thu, 19 Jul 2012 17:42:58 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by
 reworking module parameter
Message-ID: <20120719174258.33e93261@pirotess>
In-Reply-To: <201207192148.33665.hverkuil@xs4all.nl>
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com>
	<20120719154111.2e4296b9@pirotess>
	<201207192148.33665.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Jul 2012 21:48:33 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Thu July 19 2012 20:41:11 Ismael Luceno wrote:
> > On Thu, 19 Jul 2012 10:25:09 -0300
> > Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > > On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno
> > > <ismael.luceno@gmail.com> wrote:
> > > > On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia
> > > > <elezegarcia@gmail.com> wrote:
> > > >> This patch moves video_nr module parameter to core.c
> > > >> and then passes that parameter as an argument to functions
> > > >> that need it.
> > > >> This way we avoid the extern declaration and parameter
> > > >> dependencies are better exposed.
> > > > <...>
> > > >
> > > > NACK.
> > > >
> > > > The changes to video_nr are supposed to be preserved.
> > > 
> > > Mmm, I'm sorry but I don't see any functionality change in this
> > > patch, just a cleanup.
> > > 
> > > What do you mean by "changes to video_nr are supposed to be
> > > preserved"?
> > 
> > It is modified by solo_enc_alloc, which is called multiple times by
> > solo_enc_v4l2_init.
> 
> You don't need to modify it at all. video_register_device() will start
> looking for a free video node number starting at video_nr and counting
> upwards, so increasing video_nr has no purpose. Leaving it out will
> give you exactly the same result.

Oh, didn't know that. Interesting.
