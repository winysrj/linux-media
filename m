Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:34208 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbcEDLmy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 07:42:54 -0400
Date: Wed, 4 May 2016 08:42:45 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] solo6x10: Simplify solo_enum_ext_input
Message-ID: <20160504114244.GA9208@pirotess.lan>
References: <1461986229-11949-1-git-send-email-ismael@iodev.co.uk>
 <1461986229-11949-2-git-send-email-ismael@iodev.co.uk>
 <5729AC83.8050508@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5729AC83.8050508@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/Mai/2016 10:02, Hans Verkuil wrote:
> Hi Ismael,
> 
> On 04/30/2016 05:17 AM, Ismael Luceno wrote:
> > Additionally, now it specifies which channels it's showing.
> > 
> > Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
> > ---
> >  drivers/media/pci/solo6x10/solo6x10-v4l2.c | 27 +++++++++------------------
> >  1 file changed, 9 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> > index 721ff53..935c1b6 100644
> > --- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> > +++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
> > @@ -386,26 +386,17 @@ static int solo_querycap(struct file *file, void  *priv,
> >  static int solo_enum_ext_input(struct solo_dev *solo_dev,
> >  			       struct v4l2_input *input)
> >  {
> > -	static const char * const dispnames_1[] = { "4UP" };
> > -	static const char * const dispnames_2[] = { "4UP-1", "4UP-2" };
> > -	static const char * const dispnames_5[] = {
> > -		"4UP-1", "4UP-2", "4UP-3", "4UP-4", "16UP"
> > -	};
> > -	const char * const *dispnames;
> > -
> > -	if (input->index >= (solo_dev->nr_chans + solo_dev->nr_ext))
> > -		return -EINVAL;
> > -
> > -	if (solo_dev->nr_ext == 5)
> > -		dispnames = dispnames_5;
> > -	else if (solo_dev->nr_ext == 2)
> > -		dispnames = dispnames_2;
> > -	else
> > -		dispnames = dispnames_1;
> > +	int ext = input->index - solo_dev->nr_chans;
> > +	unsigned int nup, first;
> >  
> > -	snprintf(input->name, sizeof(input->name), "Multi %s",
> > -		 dispnames[input->index - solo_dev->nr_chans]);
> > +	if (ext >= solo_dev->nr_ext)
> > +		return -EINVAL;
> >  
> > +	nup   = (ext == 4) ? 16 : 4;
> > +	first = (ext & 3) << 2;
> > +	snprintf(input->name, sizeof(input->name),
> > +		 "Multi %d-up (cameras %d-%d)",
> > +		 nup, first + 1, first + nup);
> 
> Shouldn't this be: nup, first + 1, nup);
> 
> Now it displays cameras as 1-5, 2-6, 3-7, 4-8 if I am not mistaken.

Hi Hans.

The var "first" takes the values {0, 4, 8, 12}, so the code is correct,
it displays: 1-4, 5-8, 9-12, 13-16, or 1-16.

Regards.
