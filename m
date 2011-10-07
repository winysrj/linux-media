Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:49548 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965366Ab1JGLjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 07:39:22 -0400
Message-ID: <4E8EE4E7.7040300@mlbassoc.com>
Date: Fri, 07 Oct 2011 05:39:19 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <martinez.javier@gmail.com>
CC: Enrico <ebutera@users.berlios.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: omap3-isp status
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com> <CAAwP0s0Z+EaRfY_9c0QLm0ZpyfG5Dy1qb9pFq=PRxzOOTwKTJw@mail.gmail.com> <CAAwP0s1tK5XjmJmtvRFJ2+ADvoMP1ihf3z0UaJAfXOoJ=UrVqg@mail.gmail.com> <4E8DB490.7000403@mlbassoc.com> <CAAwP0s0ddOYAnC7rknLVzcN10iKAwnuOawznpKy9z6B2yWRdCg@mail.gmail.com> <CAAwP0s0tOHmdG6eWuY_QDZ6ReVFXg9S6-MSbX7s4GNEX60U2mQ@mail.gmail.com> <4E8DCD79.3060507@mlbassoc.com> <CAAwP0s15c_AgwisQvNFx-_aR44ijEz+vcB_Su3Rmiob3pPo4sw@mail.gmail.com> <4E8EC793.9010001@mlbassoc.com> <CAAwP0s0-kDjfNGPKRzGVEPuwbbVhGtPpPhK7qPitU-jWyfp1kA@mail.gmail.com> <4E8ED2CF.70302@mlbassoc.com> <CA+2YH7sZHop1es0FE5SZZbx=1e61+QSVS_FAdteFOepN_YGOEg@mail.gmail.com> <CAAwP0s31cSh+T-k=9f+_M845aQG3M5N82NPYALdVkDn5FogmWg@mail.gmail.com>
In-Reply-To: <CAAwP0s31cSh+T-k=9f+_M845aQG3M5N82NPYALdVkDn5FogmWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-07 05:02, Javier Martinez Canillas wrote:
> On Fri, Oct 7, 2011 at 12:36 PM, Enrico<ebutera@users.berlios.de>  wrote:
>> On Fri, Oct 7, 2011 at 12:22 PM, Gary Thomas<gary@mlbassoc.com>  wrote:
>>> Do we know for sure that these problems are happening in the ISP itself
>>> or could they possibly be in the TVP5150?  Does anyone have experience
>>> with a different analogue encoder?
>>
>> Never tried another encoder, but at this point it's something to look
>> at. I don't think some TI people will say "yes the encoder has
>> ghosting artifacts".
>>
>> Enrico
>>
>
> I have never tried with an different decoder either. I don't think
> this is a HW thing. As far as I know the tvp5150 is used in some
> em28xx devices that is what Mauro said, and he would notice that
> behaviour.
>
> Also, if you try getting 625 lines (for PAL) but disable the
> line-output-formatter for deinterlacing, i.e:
>
> pdata->fldmode = 0;
>
> ispccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 0);
> ispccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 0);
> ispccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 0);
> ispccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 0);
>
> Then you get a frame with the 313 odd lines and 312 even lines
> correctly. That means that the TVP5151 is generating correctly the
> interlaced video.
>
> Also the ISP is doing correctly the deinterlacing for a some frames.
> But all the approaches used so far (wait for two VD0 interrupt to
> change the CCCDC output memory direction), looks more like a hack than
> a clean solution to me, but maybe is the only way to do it with the
> ISP.

Looking at your sequence of pictures, you can see that image #10 and #11
are pretty good, but #12..14 are all bad, then #15 & 16 are OK again.
In the bad ones, it looks like every other line has been shifted left by
some number of pixels.  It's hard to tell, but I think the shift is constant
when it happens.

>
> My guess is that the problem is the ISP driver that before this
> configuration (TVP5150/1 + ISP) had never been tested with an video
> decoder that generates interlaced data.

Of course, there's the comment in the manual that says it's not supported :-)
According to 12.4.4.1, BT656 (ITU) data can only use progressive scan sensors.

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
