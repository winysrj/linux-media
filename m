Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:15227 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZE0Lk2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 07:40:28 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1567615wfd.4
        for <linux-media@vger.kernel.org>; Wed, 27 May 2009 04:40:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905271312420.5154@axis700.grange>
References: <Pine.LNX.4.64.0905271207060.5154@axis700.grange>
	 <5e9665e10905270406v5357d9d1xfacb67be9c9ec2d6@mail.gmail.com>
	 <Pine.LNX.4.64.0905271312420.5154@axis700.grange>
Date: Wed, 27 May 2009 20:40:29 +0900
Message-ID: <5e9665e10905270440o350edb98v92f6977011ca3f64@mail.gmail.com>
Subject: Re: Image filter controls
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 27, 2009 at 8:28 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Wed, 27 May 2009, Dongsoo, Nathaniel Kim wrote:
>
>> Hi Guennadi,
>>
>> In my opinion (in totally user aspect) those CIDs you mentioned do not
>> fit in the purpose. Only low-pass filtering control could be
>> considered as a colorfx, even though low-pass filtering is not a color
>> effect it could be possible to sense the meaning of effect on it. How
>> about making a new CID for band-stop filtering control and
>> V4L2_COLORFX_BORDER_DENOISING for low-pass filter?
>
> Maybe, let's see what others say. Although, the low-pass filter doesn't
> seem to be directly related to colour-transformation to me.
>

Yep, could be differ in person I guess. But if no more new CID is
allowed I think the COLORFX could be the closest one. Let's see what
others say :-)

>> BTW, would you give more information about "fluorescent light
>> band-stop filter" in detail? Because if you mean flicker control
>> caused by power line frequency, 50Hz...60Hz thing, I think we already
>> have one for that. As far as I know, V4L2_CID_POWER_LINE_FREQUENCY is
>> for that flickering control.
>
> No, here's an excerpt from a datasheet (not for the camera I'm
> implementing this, but it's the same parameter, I think):
>
> COMJ[2] - Band filter enable. After adjust frame rate to match indoor
> light frequency, this bit enable a different exposure algorithm to cut
> light band induced by fluorescent light.
>
> Not sure though how they reduce the fluorescent light by adjusting the
> exposure algorithm.

Oh, it definitely looks like a flickering control to me. Interesting
algorithm it is. I should do some research for that.
Cheers,

Nate

>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>



-- 
=
DongSoo, Nathaniel Kim
Engineer
Mobile S/W Platform Lab.
Digital Media & Communications R&D Centre
Samsung Electronics CO., LTD.
e-mail : dongsoo.kim@gmail.com
          dongsoo45.kim@samsung.com
