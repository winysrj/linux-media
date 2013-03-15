Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2608 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3COJUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Mar 2013 05:20:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Benjamin Schindler <beschindler@gmail.com>
Subject: Re: msp3400 problem in linux-3.7.0
Date: Fri, 15 Mar 2013 10:20:02 +0100
Cc: linux-media@vger.kernel.org
References: <51410709.5040805@gmail.com> <201303140844.37378.hverkuil@xs4all.nl> <5142F063.5000007@gmail.com>
In-Reply-To: <5142F063.5000007@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151020.02817.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 15 2013 10:56:51 Benjamin Schindler wrote:
> I just tried to apply the patch, but it does not apply cleanly:
> 
> metis linux # patch -p1 < /home/benjamin/Downloads/bttv-patch.txt
> patching file drivers/media/pci/bt8xx/bttv-driver.c
> Hunk #1 FAILED at 2007.
> Hunk #2 FAILED at 2024.
> Hunk #3 succeeded at 4269 with fuzz 2 (offset 34 lines).
> Hunk #4 succeeded at 4414 (offset 34 lines).
> 2 out of 4 hunks FAILED -- saving rejects to file 
> drivers/media/pci/bt8xx/bttv-driver.c.rej
> patching file drivers/media/pci/bt8xx/bttvp.h
> 
> I then tried applying it manually, which I think worked. But it did not 
> fix the problem. Given that the patch did not apply cleanly, may be I 
> should either use the media git tree or wait for 3.10.

You might want to try the media git tree (if only so that we know that it
really fixes your problem). 3.10 will be another 5 months or so before that
is released.

Regards,

	Hans

> 
> I just realized that this was on a 3.7.10 kernel (not 3.7.0, but that 
> probably does not make much of a difference)
> 
> Regards
> Benjamin
> 
> On 14.03.2013 08:44, Hans Verkuil wrote:
> > On Thu March 14 2013 08:13:29 Benjamin Schindler wrote:
> >> Hi Hans
> >>
> >> Thank you for the prompt response. I will try this once I'm home again.
> >> Which patch is responsible for fixing it? Just so I can track it once it
> >> lands upstream.
> >
> > There is a whole series of bttv fixes that I did that will appear in 3.10.
> >
> > But the patch that is probably responsible for fixing it is this one:
> >
> > http://git.linuxtv.org/media_tree.git/commit/76ea992a036c4a5d3bc606a79ef775dd32fd3daa
> >
> > I say 'probably' because I am not 100% certain that that is the main fix.
> > I'm 99% certain, though :-)
> >
> > As mentioned, it was part of a much longer patch series, so there may be other
> > patches involved in this particular problem, but I don't think so.
> >
> > If you can perhaps test just that single patch then that would be useful
> > information. If that fixes the problem then that's a candidate for 'stable'
> > kernels.
> >
> >> I have one more question - the wiki states the the WinTV-HVR-5500 is not
> >> yet supported (as of June 2011) - is there an update on this? It's the
> >> only DVB-C card I can buy in the local stores here
> >
> > No idea. I do V4L2, not DVB :-) Hopefully someone else knows.
> >
> > Regards,
> >
> > 	Hans
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
