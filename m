Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39134 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbcF0Ri6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 13:38:58 -0400
Date: Mon, 27 Jun 2016 14:38:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] tw686x: use a formula instead of two tables for div
Message-ID: <20160627143853.7e103b44@recife.lan>
In-Reply-To: <CAAEAJfD=kGG1+3zBS8A+PvVTEBva_Bw-ipNWGORGRnD1ttaqKg@mail.gmail.com>
References: <a3c0afb9b600b5284d6643bc165241eb1b81cdf6.1461770188.git.mchehab@osg.samsung.com>
	<527358bfde61acf7ac1a6e5bfc737f5645ba05a7.1461770668.git.mchehab@osg.samsung.com>
	<CAAEAJfD=kGG1+3zBS8A+PvVTEBva_Bw-ipNWGORGRnD1ttaqKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 27 Jun 2016 12:45:38 -0300
Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> escreveu:

> Hi Mauro,
> 
> Thanks a lot for the patch.
> 
> On 27 April 2016 at 12:27, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Instead of using two tables to estimate the temporal decimation
> > factor, use a formula. This allows to get the closest fps, with
> > sounds better than the current tables.
> >
> > Compile-tested only.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > [media] tw686x: cleanup the fps estimation code
> >
> > There are some issues with the old code:
> >         1) it uses two static tables;
> >         2) some values for 50Hz standards are wrong;
> >         3) it doesn't store the real framerate.
> >
> > This patch fixes the above issues.
> >
> > Compile-tested only.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > -
> >
> > v3: Patch v2 were actually a diff patch against PATCH v1. Fold the two patches in one.
> >
> > PS.: With this patch, it should be easy to add support for
> > VIDIOC_G_PARM and VIDIOC_S_PARM, as vc->fps will now store the
> > real frame rate, with should be used when returning from those
> > functions.
> >
> > ---
> >  drivers/media/pci/tw686x/tw686x-video.c | 110 +++++++++++++++++++++-----------
> >  1 file changed, 73 insertions(+), 37 deletions(-)
> >
> > diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> > index 253e10823ba3..b247a7b4ddd8 100644
> > --- a/drivers/media/pci/tw686x/tw686x-video.c
> > +++ b/drivers/media/pci/tw686x/tw686x-video.c
> > @@ -43,53 +43,89 @@ static const struct tw686x_format formats[] = {
> >         }
> >  };
> >
> > -static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
> > +static const unsigned int fps_map[15] = {
> > +       /*
> > +        * bit 31 enables selecting the field control register
> > +        * bits 0-29 are a bitmask with fields that will be output.
> > +        * For NTSC (and PAL-M, PAL-60), all 30 bits are used.
> > +        * For other PAL standards, only the first 25 bits are used.
> > +        */  
> 
> I ran a few tests and it worked perfectly fine for 60Hz standards.

Good!

> For 50Hz standards, or at least for PAL-Nc, it didn't
> work so well, and the real FPS was too different from the requested
> one. I need to look into it some more.

I would be expecting a maximum difference a little bigger than 1 Hz.

> > +       0x00000000, /* output all fields */
> > +       0x80000006, /* 2 fps (60Hz), 2 fps (50Hz) */
> > +       0x80018006, /* 4 fps (60Hz), 4 fps (50Hz) */
> > +       0x80618006, /* 6 fps (60Hz), 6 fps (50Hz) */
> > +       0x81818186, /* 8 fps (60Hz), 8 fps (50Hz) */
> > +       0x86186186, /* 10 fps (60Hz), 8 fps (50Hz) */
> > +       0x86619866, /* 12 fps (60Hz), 10 fps (50Hz) */
> > +       0x86666666, /* 14 fps (60Hz), 12 fps (50Hz) */
> > +       0x9999999e, /* 16 fps (60Hz), 14 fps (50Hz) */
> > +       0x99e6799e, /* 18 fps (60Hz), 16 fps (50Hz) */
> > +       0x9e79e79e, /* 20 fps (60Hz), 16 fps (50Hz) */
> > +       0x9e7e7e7e, /* 22 fps (60Hz), 18 fps (50Hz) */
> > +       0x9fe7f9fe, /* 24 fps (60Hz), 20 fps (50Hz) */
> > +       0x9ffe7ffe, /* 26 fps (60Hz), 22 fps (50Hz) */
> > +       0x9ffffffe, /* 28 fps (60Hz), 24 fps (50Hz) */  
> 
> Why this particular selection of fps values and bits set in each case?
> Is it arbitrary?

No. This is the same table that was already in the code:

static const unsigned int map[15] = {
                0x00000000, 0x00000001, 0x00004001, 0x00104001, 0x00404041,
                0x01041041, 0x01104411, 0x01111111, 0x04444445, 0x04511445,
                0x05145145, 0x05151515, 0x05515455, 0x05551555, 0x05555555
};

Except that the calculus that used to be there to set bit 31 to 1
on everything except map[0] and the code that makes it set two
FPS at the same time were pre-calculated, e. g. I run this code
locally to generate the new table:

	map = tw686x_fields_map(vc->video_standard, fps) << 1;
	map |= map << 1;
	if (map > 0)
		map |= BIT(31);

There, bit 31 = 0 disables the frame filtering. bit 31 = 1 enables it.

Each bit at the 0-29 bitrange means one of the 30 frames received.
If equal to 1, the frame is sent; if equal to 0, it is not sent.

So, the first value, for example: 0x80000006 has 2 consecutive
bits set, so the mean frame rate would be 2Hz. The next value there
is 0x0x80018006, with has 4 bits selected, so mean fps is 4Hz, and
so on.

As the original table always sets 2 consecutive frames at the same
time, I suspect that this is a requirement to avoid interlacing
issues.

So, the code I used to generate the table always allocate 2 consecutive
bits each time.

I suspect that such the table was built assuming that there are 30 bits,
but, on 50Hz, only 25 bits are used. So, it is sub-optimal for 50 Hz.
It means that the frames are not equally spaced.

If you want, I can construct a table for 50Hz that would produce better
results.

> 
> > +};
> > +
> > +static unsigned int tw686x_real_fps(unsigned int index, unsigned int max_fps)
> > +{
> > +       unsigned int i, bits, c = 0;
> > +
> > +       if (!index || index >= ARRAY_SIZE(fps_map))
> > +               return max_fps;
> > +
> > +       bits = fps_map[index];
> > +       for (i = 0; i < max_fps; i++)
> > +               if ((1 << i) & bits)
> > +                       c++;
> > +  
> 
> We can use hweight_long here to count the number of bits set.
> If you are OK with it, I can rework the patch and submit a new version.


-- 
Thanks,
Mauro
