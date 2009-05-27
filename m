Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:36815 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbZE0LGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 07:06:15 -0400
Received: by pzk7 with SMTP id 7so3573364pzk.33
        for <linux-media@vger.kernel.org>; Wed, 27 May 2009 04:06:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0905271207060.5154@axis700.grange>
References: <Pine.LNX.4.64.0905271207060.5154@axis700.grange>
Date: Wed, 27 May 2009 20:06:17 +0900
Message-ID: <5e9665e10905270406v5357d9d1xfacb67be9c9ec2d6@mail.gmail.com>
Subject: Re: Image filter controls
From: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

In my opinion (in totally user aspect) those CIDs you mentioned do not
fit in the purpose. Only low-pass filtering control could be
considered as a colorfx, even though low-pass filtering is not a color
effect it could be possible to sense the meaning of effect on it. How
about making a new CID for band-stop filtering control and
V4L2_COLORFX_BORDER_DENOISING for low-pass filter?

BTW, would you give more information about "fluorescent light
band-stop filter" in detail? Because if you mean flicker control
caused by power line frequency, 50Hz...60Hz thing, I think we already
have one for that. As far as I know, V4L2_CID_POWER_LINE_FREQUENCY is
for that flickering control.
Cheers,

Nate


On Wed, May 27, 2009 at 7:16 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi,
>
> I have to implement 2 filter controls: a boolean colour filter control to
> switch a fluorescent light band-stop filter on and off, and an also
> boolean control to switch a low-pass (border denoising, I think) filter. I
> found the following two filters in the existing API:
>
>        case V4L2_CID_COLOR_KILLER:             return "Color Killer";
>        case V4L2_CID_COLORFX:                  return "Color Effects";
>
> can I use one of them for the fluorescent light filter? Which one would be
> more appropriate - COLOR_KILLER means switch to BW or only kill some
> specific colour component? As for the low-pass filter, can I use
>
>        case V4L2_CID_SHARPNESS:                return "Sharpness";
>
> for it? Would it then be sharpness-off == filter-on? Or shall I add new
> controls or use driver-private ones?
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
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
