Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44299 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1H3NiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 09:38:01 -0400
Received: by pzk37 with SMTP id 37so10323102pzk.1
        for <linux-media@vger.kernel.org>; Tue, 30 Aug 2011 06:38:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108301528.57648.laurent.pinchart@ideasonboard.com>
References: <alpine.DEB.2.02.1108171551040.17540@ipanema>
	<201108301446.22411.laurent.pinchart@ideasonboard.com>
	<Pine.LNX.4.64.1108301455120.19151@axis700.grange>
	<201108301528.57648.laurent.pinchart@ideasonboard.com>
Date: Tue, 30 Aug 2011 15:38:00 +0200
Message-ID: <CABYn4szwaFN7AjiMP9stJGvduieE5+VCqLBFCVg-Vne_NcDcCQ@mail.gmail.com>
Subject: Re: [PATCH] media: Add support for arbitrary resolution for the
 ov5642 camera driver
From: Bastian Hecht <hechtb@googlemail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Laurent and others,

2011/8/30 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Guennadi,
>
> On Tuesday 30 August 2011 15:13:25 Guennadi Liakhovetski wrote:
>> On Tue, 30 Aug 2011, Laurent Pinchart wrote:
>> > On Tuesday 30 August 2011 10:55:08 Guennadi Liakhovetski wrote:
>> > > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
>> > > > On Monday 29 August 2011 14:34:53 Guennadi Liakhovetski wrote:
>> > > > > On Mon, 29 Aug 2011, Laurent Pinchart wrote:
>> > > > > > On Monday 29 August 2011 14:18:50 Guennadi Liakhovetski wrote:
>> > > > > > > On Sun, 28 Aug 2011, Laurent Pinchart wrote:
>> > > > > > >
>> > > > > > > [snip]
>> > > > > > >
>> > > > > > > > > @@ -774,17 +839,27 @@ static int ov5642_s_fmt(struct
>> > > > > > > > > v4l2_subdev *sd,
>> > > > > > > > >
>> > > > > > > > >       ov5642_try_fmt(sd, mf);
>> > > > > > > > >
>> > > > > > > > > +     priv->out_size.width            = mf->width;
>> > > > > > > > > +     priv->out_size.height           = mf->height;
>> > > > > > > >
>> > > > > > > > It looks like to me (but I may be wrong) that you achieve
>> > > > > > > > different resolutions using cropping, not scaling. If that's
>> > > > > > > > correct you should implement s_crop support and refuse
>> > > > > > > > changing the resolution through s_fmt.
>> > > > > > >
>> > > > > > > As the patch explains (I think) on several occasions, currently
>> > > > > > > only the 1:1 scale is supported, and it was our deliberate
>> > > > > > > choice to implement this using the scaling API
>> > > > > >
>> > > > > > If you implement cropping, you should use the crop API, not the
>> > > > > > scaling API
>> > > > > >
>> > > > > > :-)
>> > > > >
>> > > > > It's changing both - input and output sizes.
>> > > >
>> > > > Sure, but it's still cropping.
>> > >
>> > > Why? Isn't it a matter of the PoV?
>> >
>> > No it isn't. Cropping is cropping, regardless of how you look at it.
>> >
>> > > It changes the output window, i.e., implements S_FMT. And S_FMT is by
>> > > far more important / widely used than S_CROP. Refusing to change the
>> > > output window and always just returning the == crop size wouldn't be
>> > > polite, IMHO.
>> >
>> > If your sensor has no scaler the output size is equal to the crop
>> > rectangle. There's no way around that, and there's no reason to have the
>> > driver behave otherwise.
>> >
>> > > Don't think many users would guess to use S_CROP.
>> >
>> > Users who want to crop use S_CROP.
>> >
>> > > Standard applications a la mplayer don't use S_CROP at all.
>> >
>> > That's because they don't want to crop. mplayer expects the driver to
>> > perform scaling when it calls S_FMT, and users won't be happy if you
>> > crop instead.
>>
>> So, here's my opinion, based on the V4L2 spec. I'm going to base on this
>> and pull this patch into my tree and let Mauro decide, unless he expresses
>> his negative opinion before that.
>
> I've also made other comments. I expect at least a v2 that addresses them.

Being the author I should drop a note too, I guess. Currently I'm
working on all the comments and preparing a new set of patches. I will
of course either implement the suggestion or reply to it in 1 or 2
days.

As far as the cropping/scaling discussion is going on - I wait until
you agreed on something (what is probably not happening though ;)
before adressing it directly in the code. I don't have a real own
opinion here as I am too unexperienced. If the arguments are balanced
I would prefer leaving the code as it is :-)  but I'm open to change
it if necessary.

best regards,

 Bastian


> --
> Regards,
>
> Laurent Pinchart
>
