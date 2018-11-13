Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:23762 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbeKNHcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 02:32:13 -0500
Date: Tue, 13 Nov 2018 23:32:01 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 3/7] media: ov2640: add V4L2_CID_TEST_PATTERN control
Message-ID: <20181113213201.l7a7ekqadjr2omfp@kekkonen.localdomain>
References: <1542038454-20066-1-git-send-email-akinobu.mita@gmail.com>
 <1542038454-20066-4-git-send-email-akinobu.mita@gmail.com>
 <20181113103653.hl7ukiiy4lcphoxj@kekkonen.localdomain>
 <CAC5umyiqtu+yCUmr48mCddJa_-wM+_bHFVWjLjr0rJu3kJZALQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC5umyiqtu+yCUmr48mCddJa_-wM+_bHFVWjLjr0rJu3kJZALQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 13, 2018 at 10:55:46PM +0900, Akinobu Mita wrote:
> 2018年11月13日(火) 19:37 Sakari Ailus <sakari.ailus@linux.intel.com>:
> >
> > On Tue, Nov 13, 2018 at 01:00:50AM +0900, Akinobu Mita wrote:
> > > The ov2640 has the test pattern generator features.  This makes use of
> > > it through V4L2_CID_TEST_PATTERN control.
> > >
> > > Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> > > ---
> > >  drivers/media/i2c/ov2640.c | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
> > > index 20a8853..4992d77 100644
> > > --- a/drivers/media/i2c/ov2640.c
> > > +++ b/drivers/media/i2c/ov2640.c
> > > @@ -705,6 +705,11 @@ static int ov2640_reset(struct i2c_client *client)
> > >       return ret;
> > >  }
> > >
> > > +static const char * const ov2640_test_pattern_menu[] = {
> > > +     "Disabled",
> > > +     "Color bar",
> >
> > s/b/B/
> >
> > The smiapp driver uses "Eight Vertical Colour Bars", not sure if that'd fit
> > here or not. FYI.
> 
> This test pattern shows eight vertical color bars with blending actual
> sensor image, although the datasheet tells just 'Color bar'.
> 
> So either is fine for me.

I'll use what the smiapp driver does.

Thanks.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
