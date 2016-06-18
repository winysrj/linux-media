Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34110 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbcFRR4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 13:56:32 -0400
Date: Sat, 18 Jun 2016 10:56:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 0/2] input: add support for HDMI CEC
Message-ID: <20160618175628.GB15429@dtor-ws>
References: <1466261428-12616-1-git-send-email-hverkuil@xs4all.nl>
 <20160618162655.GC12210@dtor-ws>
 <57657D38.9080007@xs4all.nl>
 <20160618144408.5017c321@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160618144408.5017c321@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 18, 2016 at 02:44:08PM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 18 Jun 2016 18:56:24 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On 06/18/2016 06:26 PM, Dmitry Torokhov wrote:
> > > Hi Hans,
> > > 
> > > On Sat, Jun 18, 2016 at 04:50:26PM +0200, Hans Verkuil wrote:  
> > >> From: Hans Verkuil <hans.verkuil@cisco.com>
> > >>
> > >> Hi Dmitry,
> > >>
> > >> This patch series adds input support for the HDMI CEC bus through which
> > >> remote control keys can be passed from one HDMI device to another.
> > >>
> > >> This has been posted before as part of the HDMI CEC patch series. We are
> > >> going to merge that in linux-media for 4.8, but these two patches have to
> > >> go through linux-input.
> > >>
> > >> Only the rc-cec keymap file depends on this, and we will take care of that
> > >> dependency (we'll postpone merging that until both these input patches and
> > >> our own CEC patches have been merged in mainline).  
> > > 
> > > If it would be easier for you I am perfectly fine with these patches
> > > going through media tree; you have my acks on them.  
> > 
> > You're not expecting any changes to these headers for 4.8 that might
> > cause merge conflicts? That was Mauro's concern.
> > 
> > If not, then I would prefer it to go through the media tree to simplify
> > the dependencies, but it's up to Mauro.
> 
> Hi Dmitry,
> 
> My main concern is with patch 2, as it could conflict with some other
> patch on your tree, as I suspect it should be somewhat common to add
> new keystrokes from time to time, on your tree. As there's just one patch 
> affected by it from Hans CEC patch series, with adds the keymap to be 
> used by the remote controller CEC patch, it won't be a big issue to 
> delay just that patch to be sent upstream after both your and my trees 
> would be merged.

Mauro,

I created an immutable branch "cec-defines" based on 4.6; I'll also
merge it into 4.7.

Thanks.

-- 
Dmitry
