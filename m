Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:48210 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337Ab0ANRaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 12:30:24 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 14 Jan 2010 11:33:01 -0600
Subject: RE: omap34xxcam question?
Message-ID: <A24693684029E5489D1D202277BE894451539065@dlee02.ent.ti.com>
References: <4B4F0762.4040007@panicking.kicks-ass.org>
 <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com>
 <4B4F537B.7000708@panicking.kicks-ass.org>
In-Reply-To: <4B4F537B.7000708@panicking.kicks-ass.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
> Sent: Thursday, January 14, 2010 11:25 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: omap34xxcam question?
> 
> Hi,
> 
> Aguirre, Sergio wrote:
> >
> >> -----Original Message-----
> >> From: Michael Trimarchi [mailto:michael@panicking.kicks-ass.org]
> >> Sent: Thursday, January 14, 2010 6:01 AM
> >> To: linux-media@vger.kernel.org
> >> Cc: Aguirre, Sergio
> >> Subject: omap34xxcam question?
> >>
> >> Hi
> >>
> >> Is ok that it try only the first format and size? why does it not
> continue
> >> and find a matching?
> >
> > Actually, that was the intention, but I guess it was badly implemented.
> >
> > Thanks for the catch, and the contribution!
> >
> > Regards,
> > Sergio
> >> @@ -470,7 +471,7 @@ static int try_pix_parm(struct omap34xxcam_videodev
> >> *vdev,
> >>                         pix_tmp_out = *wanted_pix_out;
> >>                         rval = isp_try_fmt_cap(isp, &pix_tmp_in,
> >> &pix_tmp_out);
> >>                         if (rval)
> >> -                               return rval;
> >> +                               continue;
> >>
> 
> Is the patch good? or you are going to provide a better fix

Yes. Sorry if I wasn't clear enough.

Looks good to me, and I don't have a better fix on top of my head for the moment...

I'm assuming you tested it in your environment, right?

If yes, then I'll take the patch in my queue for submission to Sakari's tree.

Thanks for your time.

Regards,
Sergio

> 
> Michael
> 
> >> Michael
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >

