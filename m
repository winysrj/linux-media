Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4178 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2INH2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 03:28:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL] ViewCast O820E capture support added
Date: Fri, 14 Sep 2012 09:27:00 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Steven Toth <stoth@kernellabs.com>,
	"Linux-Media" <linux-media@vger.kernel.org>
References: <CALzAhNVEXexQELbbXzpzxeiUat-oXqhxQ1kiA7K1ibXTm8X+YQ@mail.gmail.com> <5052818B.7090708@redhat.com> <505291E6.9020606@redhat.com>
In-Reply-To: <505291E6.9020606@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209140927.00426.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 14 2012 04:09:42 Mauro Carvalho Chehab wrote:
> Em 13-09-2012 21:59, Mauro Carvalho Chehab escreveu:
> > Em Thu, 13 Sep 2012 20:23:42 -0300
> > Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
> > 
> >> Em 13-09-2012 20:19, Mauro Carvalho Chehab escreveu:
> >>> Em Sat, 18 Aug 2012 11:48:52 -0400
> >>> Steven Toth <stoth@kernellabs.com> escreveu:
> >>>
> >>>> Mauro, please read below, a new set of patches I'm submitting for merge.
> >>>>
> >>>> On Thu, Aug 16, 2012 at 2:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>>>> On Thu August 16 2012 19:39:51 Steven Toth wrote:
> >>>>>>>> So, I've ran v4l2-compliance and it pointed out a few things that I've
> >>>>>>>> fixed, but it also does a few things that (for some reason) I can't
> >>>>>>>> seem to catch. One particular test is on (iirc) s_fmt. It attempts to
> >>>>>>>> set ATSC but by ioctl callback never receives ATSC in the norm/id arg,
> >>>>>>>> it actually receives 0x0. This feels more like a bug in the test.
> >>>>>>>> Either way, I have some if (std & ATSC) return -EINVAL, but it still
> >>>>>>>> appears to fail the test.
> >>>>>>
> >>>>>> Oddly enough. If I set tvnorms to something valid, then compliance
> >>>>>> passes but gstreamer
> >>>>>> fails to run, looks like some kind of confusion about either the
> >>>>>> current established
> >>>>>> norm, or a failure to establish a norm.
> >>>>>>
> >>>>>> For the time being I've set tvnorms to 0 (with a comment) and removed
> >>>>>> current_norm.
> >>>>>
> >>>>> Well, this needs to be sorted, because something is clearly amiss.
> >>>>
> >>>> Agreed. I just can't see what's wrong. I may need your advise /
> >>>> eyeballs on this. I'd be willing to provide logs that show gstreamer
> >>>> accessing the driver and exiting. It needs fixed, I've tried, I just
> >>>> can't see why gstreamer fails.
> >>>>
> >>>> On the main topic of merge.... As promised, I spent quite a bit of
> >>>> time this week reworking the code based on the feedback. I also
> >>>> flattened all of these patches into a single patchset and upgraded to
> >>>> the latest re-org tree.
> >>>>
> >>>> The source notes describe in a little more detail the major changes:
> >>>> http://git.kernellabs.com/?p=stoth/media_tree.git;a=commit;h=f295dd63e2f7027e327daad730eb86f2c17e3b2c
> >>>>
> >>>> Mauro, so, I hereby submit for your review/merge again, the updated
> >>>> patchset. *** Please comment. ***
> >>>
> >>> I'll comment patch by patch. Let's hope the ML will get this email. Not sure,
> >>> as it tends to discard big emails like that.
> >>>
> >>> This is the comment of patch 1/4.
> >>>
> >>
> >> Patch 2 is trivial. It is obviously OK.
> >>
> >> Patch 3 also looked OK on my eyes.
> > 
> > Patch 4 will very likely be discarded by vger server, if everything is
> > added there. So, I'll drop the parts that weren't commented.
> > 
> > Anyway:
> > 
> >> Subject: [media] vc8x0: Adding support for the ViewCast O820E Capture Card.
> >> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> >>
> >> A dual channel 1920x1080p60 PCIe x4 capture card, two DVI
> >> inputs capable of capturing DVI/HDMI, Component, Svideo, Composite
> >> and some VGA resolutions.
> > ...
> > 


> >> diff --git a/drivers/media/pci/vc8x0/vc8x0-display.c b/drivers/media/pci/vc8x0/vc8x0-display.c
> > 
> >> +struct letter_t {
> >> +	u8 *ptr;
> >> +	u8 data[8];
> >> +} charset[] = {
> >> + /* ' ' */ [0x20] = { 0, { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, },
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* '!' */ [0x21] = { 0, { 0x04, 0x04, 0x04, 0x04, 0x00, 0x00, 0x04, 0x00 }, },
> >> + /* 00000100 */
> >> + /* 00000100 */
> >> + /* 00000100 */
> >> + /* 00000100 */
> >> + /* 00000000 */
> >> + /* 00000000 */
> >> + /* 00000100 */
> >> + /* 00000000 */
> > 
> > Charset???? No, please! If you really need a charset, take a look at the
> > vivi driver. It uses an already-existent Kernel charset. See:
> > 
> > 	static int __init vivi_init(void)
> > 	{
> > 		const struct font_desc *font = find_font("VGA8x16");
> > 
> > Not sure about the rest of the code here at vc8x0-display.c, but maybe you'll
> > find a similar code to it already coded. Where do you use it?

I think all this is just for debugging and should just be removed. It renders
debugging text in the frame.

> > diff --git a/drivers/media/pci/vc8x0/vc8x0-video.c b/drivers/media/pci/vc8x0/vc8x0-video.c
> 

> > +static int vc8x0_video_generate_osd(struct vc8x0_dma_channel *channel, u8 *dst)
> > +{
> > +#if 1
> > +	return 0;
> > +#else
> > +	/* Do some text rendering */
> > +	struct vc8x0_format *fmt = channel->ad7441_ctx.detected_fmt;
> > +	unsigned char tmp[256];
> > +	int ret;
> > +
> > +	ret = vc8x0_display_render_reset(&channel->display_ctx, dst,
> > +		channel->fmt->width);
> > +	if (ret < 0)
> > +		return ret;
> 
> Hmm... Are you using the *-display.c code for OSD? Not sure if it is
> a good idea to handle it like that.
> 
> Hans,
> 
> What do you think?
> 
> Yet, the code here is commented, but there's a hole driver there in order
> to implement OSD display, just bloating the driver's code... 

I think it can all be removed completely. It's not a real OSD, it just
renders text in a captured frame.

> > +static int vc8x0_log_status(struct file *file, void *priv)
> > +{
> > +	struct vc8x0_dma_channel *channel = ((struct vc8x0_fh *)priv)->channel;
> > +	struct vc8x0_dev *dev = channel->dev;
> > +
> > +	v4l2_subdev_call(channel->sd_adv7441a, core, log_status);
> > +	v4l2_subdev_call(dev->dma_channel[DMA_CHANNEL9].sd_pcm3052,
> > +		core, log_status);
> > +
> > +	return 0;
> > +}
> 
> I think this is only available with advanced debug.

No, this is always available. Only g/s_dbg_register are under advanced debug.

Regards,

	Hans
