Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:46370 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3IQPiT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Sep 2013 11:38:19 -0400
Received: by mail-we0-f172.google.com with SMTP id w61so5360355wes.31
        for <linux-media@vger.kernel.org>; Tue, 17 Sep 2013 08:38:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5238720B.7040106@sca-uk.com>
References: <523769B0.6070908@sca-uk.com>
	<CAGoCfiwVPGKSYOObirz+X3_AN6S1LL5Eff9kcWswcHx-msguiA@mail.gmail.com>
	<5238720B.7040106@sca-uk.com>
Date: Tue, 17 Sep 2013 11:38:17 -0400
Message-ID: <CAGoCfiwYHXWBe-SLix-Qep9Ciu94iir66_oc9CmJSmaa8UBg7Q@mail.gmail.com>
Subject: Re: Canvassing for Linux support for Startech PEXHDCAP
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Cookson <it@sca-uk.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Steven Toth <stoth@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 17, 2013 at 11:15 AM, Steve Cookson <it@sca-uk.com> wrote:
> On 16/09/2013 19:09, Devin Heitmueller wrote:
>> To be clear, this card is a *raw* capture card.  It does not have any
>> hardware compression for H.264.  It's done entirely in software.
>
> Ok, well I misunderstood that.  And, in addition, I also thought that
> hardware encoding *reduced* latency, something you seem to indicate is not
> true.

Nope, the opposite.  In order to compress the video you need to store
enough context to look for repetition.  H.264 encoders can vary in
latency, and in fact some can be adjusted to reduce latency at the
cost of compression performance.  But they will always have more
latency than just reading the raw video as it comes in.

> If this is stored in a file, somehow it needs to be encoded, I just imagined
> that metal was faster than code.

If your intent is to store the video in a file, then you almost
certainly will need to encode it with a scheme such as H.264.  However
raw capture cards can be very useful for cases where you want to take
in the video, alter it somehow, and then put it back out to the
display (think digital signage).  Capturing raw video also allows the
consumer to have better control over the actual compression process
(since it's done in software), which is why it is preferred for
professional capture application (which is why BlackMagic doesn't make
any cards with hardware encoders).  Cost isn't a concern and those
sorts of customers are willing to have high end workstations to
actually work with the uncompressed video.

>> Aside from the Mstar video decoder (for which there is no public
>> documentation), you would also need a driver for the saa7160 chip,
>> which there have been various half-baked drivers floating around but
>> nothing upstream, and none of them currently support HD capture
>> (AFAIK).
>
> Well the chip thing is confusing me.
>
> 1) I don't understand the difference between the MST3367CMK-LF-170 and the
> saa7160.  Is one analogue and one digital?  Or do they perform different
> steps in the process (like one does encoding and one does the DMA thing?

The Mstar chip encodes the analog signal to a digital format.  The
saa7160 takes the resulting digital signal and makes it available to
the host via DMA.

> 2) If you look here,
>
> http://katocctv.en.alibaba.com/product/594834688-213880911/1080p_PCIe_Video_Grabber_Video_Capture_Card.html
>
> You'll see a very similar card with an extra chip.  You can just see that it
> is produced by Gennum (but I can't see the number).  There is also another
> chip on the underside, maybe this is the saa7160? And maybe it's on the
> underside of the PEXHDCAP too.  This is actually the one I saw working.  As
> I say it was very fast and high quality, but under windows.

The "extra" chip is for SDI capture, which isn't supported by the
lower cost mstar chip (which is designed for HDMI and component).  The
bridge is the chip nearest the PCIe connector, which can be a saa7160
or some other component.

> Scroll down and you see this:
>
>     Operation System: WINDOWS XP /VISTA/ 7 Linux 2.6. 14 or higher (32-bit
> and 64-bit)
>
> Drilling into this, it appeared the statement was more aspirational than
> actual, but that it *had* been compatible, but there was not yet an
> available driver.  They would need to recompile something to include the
> latest linux libraries before it would be possible to write the drivers.
> I've no idea what this could mean.  Although 2 clients had indeed written
> gstreamer drivers, one was Cisco systems, but had kept the code to
> themselves.

Who knows?  So much of that junk on alibaba is cut/pasted from other
products and isn't actually accurate.  Or maybe somebody does have a
driver.  There's nothing in the mainline kernel though.

>> and none of them currently support HD capture (AFAIK).
>
> What does this mean?  No saa7160 drivers, or no drivers period?  I have the
> Intensity Pro doing full-screen 1080i capture with minimal latency, but I
> hate the decklinksrc module.  It just does nearly nothing.  Maybe it could
> be re-written for v4l2src, but anyway it only accepts YPbPr, as I said
> before.

The Blackmagic boards are the only low cost boards out there which
have readily available drivers.  The downside is you have to deal with
their proprietary interface that isn't remotely V4L2 compatible (and
thus only works with their applications or if you're prepared to write
your own app).

We wrote open source drivers for a couple of the ViewCast boards which
do HDMI/DVI capture, but while the drivers are free the boards
themselves can cost a couple thousand dollars.

>> As always, a driver *can* be written, but it would be a rather large
>> project (probably several weeks of an engineer working full time on
>> it, assuming the engineer has experience in this area).  In this case
>> it's worse because a significant amount of reverse engineering would
>> be required.
>
> Kato Vision agreed with you.  They were saying a few months (maybe two or
> three).  They didn't offer to write it, but they offered technical support
> with the driver-writing.

Yup.  We've been through the exercise several times with various HD
capture boards.  Adjust the multiplier based on the level of
experience of the developer doing the work.  :-)

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
