Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65069 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932604AbbBIQIb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2015 11:08:31 -0500
Received: by mail-wi0-f170.google.com with SMTP id hm9so6766963wib.1
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2015 08:08:30 -0800 (PST)
Date: Mon, 9 Feb 2015 16:06:30 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: divide error: 0000 in the gspca_topro
Message-ID: <20150209160630.GA5332@biggie>
References: <54D7E0B8.30503@reflexion.tv>
 <CA+55aFxB4Wq-Bob_+q0c3oS1hUf_BLGqqyoepGRDvm9-X2Y+og@mail.gmail.com>
 <20150209102348.GB28420@biggie>
 <20150209135656.11cc85e6@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150209135656.11cc85e6@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 09, 2015 at 01:56:56PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 09 Feb 2015 10:23:48 +0000
> Luis de Bethencourt <luis@debethencourt.com> escreveu:
> 
> > On Sun, Feb 08, 2015 at 06:07:45PM -0800, Linus Torvalds wrote:
> > > I got this, and it certainly seems relevant,.
> > > 
> > > It would seem that that whole 'quality' thing needs some range
> > > checking, it should presumably be in the range [1..100] in order to
> > > avoid negative 'sc' values or the divide-by-zero.
> > > 
> > > Hans, Mauro?
> > > 
> > >                       Linus
> > 
> > Hello Linus,
> > 
> > The case of quality being set to 0 is correctly handled in
> > drivers/media/usb/gspca/jpeg.h [0], so I have sent a patch to do the same
> > in topro.c.
> 
> Patch looks good to me.
> 
> I'll double check if some other driver has the same bad handling for
> quality set and give a couple days for Hans to take a look.
> 
> If he's fine with this approach, I'll add it on a separate pull request.
> 
> Regards,
> Mauro
> 

Hi Mauro,

Thanks for taking the time to look at this.

After sending the patch I searched around for any similar cases, only
finding coda/coda-jpeg.c [0], but in this case the quality is clipped to 5 if
it is < 5.

I might have missed some other case though. Just letting you know to help you
save some time.

Cheers,
Luis

[0] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/platform/coda/coda-jpeg.c#n216

> > 
> > Thanks,
> > Luis
> > 
> > [0] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/media/usb/gspca/jpeg.h#n157
> > 
> > > 
> > > ---------- Forwarded message ----------
> > > From: Peter Kovář <peter.kovar@reflexion.tv>
> > > Date: Sun, Feb 8, 2015 at 2:18 PM
> > > Subject: divide error: 0000 in the gspca_topro
> > > To: Linus Torvalds <torvalds@linux-foundation.org>
> > > 
> > > 
> > > Hi++ Linus!
> > > 
> > > There is a trivial bug in the gspca_topro webcam driver.
> > > 
> > > /* set the JPEG quality for sensor soi763a */
> > > static void jpeg_set_qual(u8 *jpeg_hdr,
> > >                           int quality)
> > > {
> > >         int i, sc;
> > > 
> > >         if (quality < 50)
> > >                 sc = 5000 / quality;
> > >         else
> > >                 sc = 200 - quality * 2;
> > > 
> > > 
> > > 
> > > Crash can be reproduced by setting JPEG quality to zero in the guvcview
> > > application.
> > > 
> > > Cheers,
> > > 
> > > Peter Kovář
> > > 50 65 74 65 72 20 4B 6F 76 C3 A1 C5 99
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
