Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58618 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab1JGLDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 07:03:17 -0400
Received: by qyk7 with SMTP id 7so3466521qyk.19
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 04:03:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+2YH7sZHop1es0FE5SZZbx=1e61+QSVS_FAdteFOepN_YGOEg@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
 <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com>
 <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com>
 <4E8DB490.7000403@mlbassoc.com> <CAAwP0s0ddOYAnC7rknLVzcN10iKAwnuOawznpKy9z6B2yWRdCg@mail.gmail.com>
 <CAAwP0s0tOHmdG6eWuY_QDZ6ReVFXg9S6-MSbX7s4GNEX60U2mQ@mail.gmail.com>
 <4E8DCD79.3060507@mlbassoc.com> <CAAwP0s15c_AgwisQvNFx-_aR44ijEz+vcB_Su3Rmiob3pPo4sw@mail.gmail.com>
 <4E8EC793.9010001@mlbassoc.com> <CAAwP0s0-kDjfNGPKRzGVEPuwbbVhGtPpPhK7qPitU-jWyfp1kA@mail.gmail.com>
 <4E8ED2CF.70302@mlbassoc.com> <CA+2YH7sZHop1es0FE5SZZbx=1e61+QSVS_FAdteFOepN_YGOEg@mail.gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 7 Oct 2011 13:02:57 +0200
Message-ID: <CAAwP0s31cSh+T-k=9f+_M845aQG3M5N82NPYALdVkDn5FogmWg@mail.gmail.com>
Subject: Re: omap3-isp status
To: Enrico <ebutera@users.berlios.de>
Cc: Gary Thomas <gary@mlbassoc.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 7, 2011 at 12:36 PM, Enrico <ebutera@users.berlios.de> wrote:
> On Fri, Oct 7, 2011 at 12:22 PM, Gary Thomas <gary@mlbassoc.com> wrote:
>> Do we know for sure that these problems are happening in the ISP itself
>> or could they possibly be in the TVP5150?  Does anyone have experience
>> with a different analogue encoder?
>
> Never tried another encoder, but at this point it's something to look
> at. I don't think some TI people will say "yes the encoder has
> ghosting artifacts".
>
> Enrico
>

I have never tried with an different decoder either. I don't think
this is a HW thing. As far as I know the tvp5150 is used in some
em28xx devices that is what Mauro said, and he would notice that
behaviour.

Also, if you try getting 625 lines (for PAL) but disable the
line-output-formatter for deinterlacing, i.e:

pdata->fldmode = 0;

ispccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 0);
ispccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 0);
ispccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 0);
ispccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 0);

Then you get a frame with the 313 odd lines and 312 even lines
correctly. That means that the TVP5151 is generating correctly the
interlaced video.

Also the ISP is doing correctly the deinterlacing for a some frames.
But all the approaches used so far (wait for two VD0 interrupt to
change the CCCDC output memory direction), looks more like a hack than
a clean solution to me, but maybe is the only way to do it with the
ISP.

My guess is that the problem is the ISP driver that before this
configuration (TVP5150/1 + ISP) had never been tested with an video
decoder that generates interlaced data.

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
