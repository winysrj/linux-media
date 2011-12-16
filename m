Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50242 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1LPHlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 02:41:04 -0500
Date: Fri, 16 Dec 2011 09:40:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, dacohen@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl
Subject: Re: [RFC 1/3] v4l: Add pixel clock to struct v4l2_mbus_framefmt
Message-ID: <20111216074058.GI3677@valkosipuli.localdomain>
References: <20111201143044.GI29805@valkosipuli.localdomain>
 <1323876147-18107-1-git-send-email-sakari.ailus@iki.fi>
 <4EEA6AAE.80405@gmail.com>
 <20111215220150.GH3677@valkosipuli.localdomain>
 <4EEA727C.6010906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EEA727C.6010906@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Dec 15, 2011 at 11:19:40PM +0100, Sylwester Nawrocki wrote:
> On 12/15/2011 11:01 PM, Sakari Ailus wrote:
> >>>  	  <entry>__u32</entry>
> >>> -	  <entry><structfield>reserved</structfield>[7]</entry>
> >>> +	  <entry><structfield>pixel_clock</structfield></entry>
> >>> +	  <entry>Pixel clock in kHz. This clock is the maximum rate at
> >>> +	  which pixels are transferred on the bus. The pixel_clock
> >>> +	  field is read-only.</entry>
> >>
> >> I searched a couple of datasheets to find out where I could use this pixel_clock
> >> field but didn't find any so far. I haven't tried too hard though ;)
> >> There seems to be more benefits from having the link frequency control.
> > 
> > There are a few reasons to have the pixel clock available to the user space.
> > 
> > The previously existing reason is that the user may get information on the
> > pixel rates, including cases where the pixel rate of a subdev isn't enough
> > for the streaming to be possible. Earlier on it just failed. Such cases are
> > common on the OMAP 3 ISP, for example.
> > 
> > The second reason is to provide that for timing calculations in the user
> > space.
> 
> Fair enough. Perhaps, if I have worked more with image signal processing
> algorithms in user space I would not ask about that in the first place :-)

It's not only the algorithms, but it gives you a way to perform low level
sensor configuration. It gives the user an easy way to configure the frame
rate freely between a range which is easy to obtain, and also taking into
account the policy decisions instead of the kernel doing them for the user.

There's more in the parent, albeit I forgot to mention the above:

<URL:http://www.spinics.net/lists/linux-media/msg40861.html>

> 
> > 
> >> It might be easy to confuse pixel_clock with the bus clock. The bus clock is
> >> often referred in datasheets as Pixel Clock (PCLK, AFAIU it's described with
> >> link frequency in your RFC). IMHO your original proposal was better, i.e.
> >> using more explicit pixel_rate. Also why it is in kHz ? Doesn't it make more
> >> sense to use bits or pixels  per second ?
> > 
> > Oh, yes, now that you mention it I did call it pixel rate. I'm fine
> > withrenaming it back to e.g. "pixelrate".
> 
> I'm fine with that too, sounds good!
> 
> > 
> > I picked kHz since the 32-bit field would allow rates up to 4 GiP/s. Not
> > sure if that's overkill though. Could be. But in practice it should give
> > good enough precision this way, too.
> 
> All right, however I was more concerned by the "Hz" part, rather than "k" ;)
> It might be good to have the relevant unit defined in the spec, to avoid
> misinterpretation and future interoperability issues .

Indeed. kp/s then? :-)

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
