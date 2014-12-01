Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63811 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbaLAPl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 10:41:29 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so14547588wgh.39
        for <linux-media@vger.kernel.org>; Mon, 01 Dec 2014 07:41:27 -0800 (PST)
Date: Mon, 1 Dec 2014 16:41:56 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, marbugge@cisco.com,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] hdmi: added unpack and logging functions for
 InfoFrames
Message-ID: <20141201154156.GU32117@phenom.ffwll.local>
References: <1417186251-6542-1-git-send-email-hverkuil@xs4all.nl>
 <1417186251-6542-3-git-send-email-hverkuil@xs4all.nl>
 <20141201131507.GB11763@ulmo.nvidia.com>
 <547C71BF.4040907@xs4all.nl>
 <20141201153329.GC11943@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141201153329.GC11943@ulmo.nvidia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 01, 2014 at 04:33:31PM +0100, Thierry Reding wrote:
> On Mon, Dec 01, 2014 at 02:48:47PM +0100, Hans Verkuil wrote:
> > Hi Thierry,
> > 
> > Thanks for the review, see my comments below.
> > 
> > On 12/01/2014 02:15 PM, Thierry Reding wrote:
> > > On Fri, Nov 28, 2014 at 03:50:50PM +0100, Hans Verkuil wrote:
> [...]
> > >> +{
> > >> +	switch (type) {
> > >> +	case HDMI_INFOFRAME_TYPE_VENDOR: return "Vendor";
> > >> +	case HDMI_INFOFRAME_TYPE_AVI: return "Auxiliary Video Information (AVI)";
> > >> +	case HDMI_INFOFRAME_TYPE_SPD: return "Source Product Description (SPD)";
> > >> +	case HDMI_INFOFRAME_TYPE_AUDIO: return "Audio";
> > > 
> > > I'd prefer "case ...:" and "return ...;" on separate lines for
> > > readability.
> > 
> > I actually think that makes it *less* readable. If you really want that, then I'll
> > change it, but I would suggest that you try it yourself first to see if it is
> > really more readable for you. It isn't for me, so I'll keep this for the next
> > version.
> 
> I did, and I still think separate lines are more readable, especially if
> you throw in a blank line after the "return ...;". Anyway, I could keep
> my OCD in check if it weren't for the fact that half of these are the
> cause for checkpatch to complain. And then if you change the ones that
> checkpatch wants you to change, all the others would be inconsistent and
> then I'd complain about the inconsistency...

Throwing in my own unasked-for bikshed opinion ;-)

I agree with Thierry that it's more readable since this way the key and
the value can be lined up easily. That's also possible with the
single-line case/return like you do with some more tabs, but usually means
all the lines overflow the 80 limit badly. So only really works for small
defines/values. So my rule of thumb is
- go with single-line case/return and align them
- but break the lines if they would be too long.

Now back to doing useful stuff for me.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
