Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1808 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2GSTtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jul 2012 15:49:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ismael Luceno <ismael.luceno@gmail.com>
Subject: Re: [PATCH 10/10] staging: solo6x10: Avoid extern declaration by reworking module parameter
Date: Thu, 19 Jul 2012 21:48:33 +0200
Cc: Ezequiel Garcia <elezegarcia@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1340308332-1118-1-git-send-email-elezegarcia@gmail.com> <CALF0-+W88U_cAGMrui9rwbNg8BBgekBi9B2unStKySY_RhS3zw@mail.gmail.com> <20120719154111.2e4296b9@pirotess>
In-Reply-To: <20120719154111.2e4296b9@pirotess>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207192148.33665.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu July 19 2012 20:41:11 Ismael Luceno wrote:
> On Thu, 19 Jul 2012 10:25:09 -0300
> Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> > On Wed, Jul 18, 2012 at 7:26 PM, Ismael Luceno
> > <ismael.luceno@gmail.com> wrote:
> > > On Thu, Jun 21, 2012 at 4:52 PM, Ezequiel Garcia
> > > <elezegarcia@gmail.com> wrote:
> > >> This patch moves video_nr module parameter to core.c
> > >> and then passes that parameter as an argument to functions
> > >> that need it.
> > >> This way we avoid the extern declaration and parameter
> > >> dependencies are better exposed.
> > > <...>
> > >
> > > NACK.
> > >
> > > The changes to video_nr are supposed to be preserved.
> > 
> > Mmm, I'm sorry but I don't see any functionality change in this patch,
> > just a cleanup.
> > 
> > What do you mean by "changes to video_nr are supposed to be
> > preserved"?
> 
> It is modified by solo_enc_alloc, which is called multiple times by
> solo_enc_v4l2_init.

You don't need to modify it at all. video_register_device() will start
looking for a free video node number starting at video_nr and counting
upwards, so increasing video_nr has no purpose. Leaving it out will give
you exactly the same result.

The only driver that does the same thing is vivi, and I think it should
be removed from there as well. The solo driver probably copied it from
vivi :-(

Regards,

	Hans
