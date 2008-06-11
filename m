Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5BKhfCH005292
	for <video4linux-list@redhat.com>; Wed, 11 Jun 2008 16:43:46 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5BKFS07022363
	for <video4linux-list@redhat.com>; Wed, 11 Jun 2008 16:15:29 -0400
Date: Wed, 11 Jun 2008 22:15:02 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <20080611201501.GA1823@daniel.bse>
References: <200805262326.30501.hverkuil@xs4all.nl>
	<200805270900.20790.hverkuil@xs4all.nl>
	<1212791383.17465.742.camel@localhost>
	<200806112049.36291.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806112049.36291.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, mschimek@gmx.at
Subject: Re: Need VIDIOC_CROPCAP clarification
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, Jun 11, 2008 at 08:49:36PM +0200, Hans Verkuil wrote:
> Note: bounds and defrect are very strange in that width and height have 
> pixels as units and top and left have their own units (although in 
> practice it also uses pixels as the unit). This is not at all obvious 
> from the spec! Also, is there any reason why we shouldn't uses pixels 
> as well as the top/left unit? See more about this below.

I don't think it was supposed to be like that.
All four members use the same units.

> Note that examples 1-12 and 1-13 in the spec clearly assume that the 
> crop units are pixels! And I think all drivers we have do the same.

Michael's mail from 2002 does that as well and as he said a few days
ago, the cropping units should be pixels at maximum unscaled resolution.

> 3) CROPCAP returns the pixelaspect of the pixels you capture when you 
> use defrect.width/height as the width and height with S_FMT and 
> defrect.width/height with S_CROP. Non-standard cropping and scaling 
> means that you will have to calculate the new pixelaspect by taking 
> that into account. This also does not take things like anamorphic 
> widescreen into account, you have to detect that yourself and adjust 
> accordingly.

I read that as well in the 2002 mail.

> It's really this sentence that makes things so hard: 'the driver writer 
> is free to choose origin and units of the coordinate system in the 
> analog domain.' If that was replaced by: 'the driver writer is free to 
> choose the origin of the coordinate system.' then it would make a lot 
> more sense.

And the units are pixels at the highest resolution without upscaling.
(regardless of the possible cropping granularity)


The current standard does not allow to derive the position and size of
an image in the tv signal from cropping values.
The only thing known is that defrect is centered over and bigger or equal
than the active area iff hardware permits to crop such an area.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
