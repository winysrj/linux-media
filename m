Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43493 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2IPE4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 00:56:49 -0400
Received: by weyx8 with SMTP id x8so3208365wey.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 21:56:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120828204823.GE3191@zeus>
References: <1345411489.22400.76.camel@deadeye.wl.decadent.org.uk>
	<1345419147.22400.78.camel@deadeye.wl.decadent.org.uk>
	<20120828114409.GA3191@zeus>
	<1346173795.15747.28.camel@deadeye.wl.decadent.org.uk>
	<20120828204823.GE3191@zeus>
Date: Sun, 16 Sep 2012 12:56:47 +0800
Message-ID: <CAKcpw6WvCM99-VzqOOFYiB7ggKNp57coRB6E5f3ep2218C1zOQ@mail.gmail.com>
Subject: Re: [PATCH v2] [media] rc: ite-cir: Initialise ite_dev::rdev earlier
From: YunQiang Su <wzssyqa@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	684441@bugs.debian.org, Jarod Wilson <jarod@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I upgrade my system yesterday, and this morning, it panic always, even
I boot another system
first and reboot.

Both the kernel in testing and experimental have this problem.

On Wed, Aug 29, 2012 at 4:48 AM, Luis Henriques
<luis.henriques@canonical.com> wrote:
> On Tue, Aug 28, 2012 at 10:09:55AM -0700, Ben Hutchings wrote:
>> On Tue, 2012-08-28 at 12:44 +0100, Luis Henriques wrote:
>> > On Mon, Aug 20, 2012 at 12:32:27AM +0100, Ben Hutchings wrote:
>> > > ite_dev::rdev is currently initialised in ite_probe() after
>> > > rc_register_device() returns.  If a newly registered device is opened
>> > > quickly enough, we may enable interrupts and try to use ite_dev::rdev
>> > > before it has been initialised.  Move it up to the earliest point we
>> > > can, right after calling rc_allocate_device().
>> >
>> > I believe this is the same bug:
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=46391
>> >
>> > And the bug is present in other IR devices as well.
>> >
>> > I've sent a proposed fix:
>> >
>> > http://marc.info/?l=linux-kernel&m=134590803109050&w=2
>>
>> It might be a worthwhile fix.  But it doesn't fix this bug - after that
>> patch, the driver will still enable its IRQ before initialising
>> ite_dev::rdev.
>
> You're absolutely right, sorry for the noise.  I should have taken a
> closer look at your patch.
>
> Cheers,
> --
> Luis
>
>>
>> Ben.
>>
>> > Cheers,
>> > --
>> > Luis
>> >
>> > >
>> > > References: http://bugs.debian.org/684441 Reported-and-tested-by:
>> > > YunQiang Su <wzssyqa@gmail.com> Signed-off-by: Ben Hutchings
>> > > <ben@decadent.org.uk> Cc: stable@vger.kernel.org --- Unlike the
>> > > previous version, this will apply cleanly to the media
>> > > staging/for_v3.6 branch.
>> > >
>> > > Ben.
>> > >
>> > >  drivers/media/rc/ite-cir.c |    2 +-
>> > >  1 file changed, 1 insertion(+), 1 deletion(-)
>> > >
>> > > diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
>> > > index 36fe5a3..24c77a4 100644
>> > > --- a/drivers/media/rc/ite-cir.c
>> > > +++ b/drivers/media/rc/ite-cir.c
>> > > @@ -1473,6 +1473,7 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>> > >   rdev = rc_allocate_device();
>> > >   if (!rdev)
>> > >           goto failure;
>> > > + itdev->rdev = rdev;
>> > >
>> > >   ret = -ENODEV;
>> > >
>> > > @@ -1604,7 +1605,6 @@ static int ite_probe(struct pnp_dev *pdev, const struct pnp_device_id
>> > >   if (ret)
>> > >           goto failure3;
>> > >
>> > > - itdev->rdev = rdev;
>> > >   ite_pr(KERN_NOTICE, "driver has been successfully loaded\n");
>> > >
>> > >   return 0;
>> > >
>> >
>>
>> --
>> Ben Hutchings
>> It is a miracle that curiosity survives formal education. - Albert Einstein



-- 
YunQiang Su
