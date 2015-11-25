Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp04.uk.clara.net ([195.8.89.37]:52992 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbbKYJxx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2015 04:53:53 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cx18: Fix VIDIOC_TRY_FMT to fill in sizeimage and bytesperline
Date: Wed, 25 Nov 2015 09:53:45 +0000
Message-ID: <4726783.suCipCVCmC@f19simon>
In-Reply-To: <CAH-u=81v76v0dYb64RAF-q0fuF2TCor=SKm3h3POpxOO5Fb4YA@mail.gmail.com>
References: <1448388580-22082-1-git-send-email-simon.farnsworth@onelan.co.uk> <CAH-u=81v76v0dYb64RAF-q0fuF2TCor=SKm3h3POpxOO5Fb4YA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 24 November 2015 21:27:33 Jean-Michel Hautbois wrote:

> Hi, 
> Le 24 nov. 2015 19:46, "Simon Farnsworth" <simon.farnsworth@onelan.co.uk> a écrit :
> >
> > I was having trouble capturing raw video from GStreamer; turns out that I
> > now need VIDIOC_TRY_FMT to fill in sizeimage and bytesperline to make it work.
> 
> You could have used v4l2-compliance tool it would give you at least (I don't have the HW to test) this error. Would save your time :-) 

It only took me 2 minutes to find - I'd have spent longer getting
v4l2-compliance running :)

As I'm not going to have access to the hardware after Friday, I'll leave
getting a full v4l2-compliance pass to someone else.

> > Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> > ---
> >
> > I'm leaving ONELAN on Friday, so this is a drive-by patch being sent for the
> > benefit of anyone else trying to use raw capture from a cx18 card. If it's
> > not suitable for applying as-is, please feel free to just leave it in the
> > archives so that someone else hitting the same problem can find my fix.
> >
<snip>

-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

