Return-path: <mchehab@pedra>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:38112 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517Ab1CAJrH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Mar 2011 04:47:07 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 1 Mar 2011 17:46:36 +0800
Subject: RE: isp or soc-camera for image co-processors
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEFA598FC@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
 <201103011041.03424.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103011041.03424.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Tuesday, March 01, 2011 3:11 PM
> To: Bhupesh SHARMA
> Cc: Guennadi Liakhovetski; linux-media@vger.kernel.org
> Subject: Re: isp or soc-camera for image co-processors
> 
> Hi Bhupesh,
> 
> On Tuesday 01 March 2011 08:25:12 Bhupesh SHARMA wrote:
> > Hi Guennadi and Laurent,
> >
> > We are now evaluating another ST platform that supports a image
> > co-processor between the camera sensor and the camera host (SoC).
> >
> > The simple architecture diagram will be similar to one shown below
> > (for the sake of simplicity I show only a single sensor. At least
> > two sensors can be supported by the co-processor):
> 
> [snip] (as the ascii-art looks more like a Picasso painting with the
> quote
> characters)

:(
Despite my efforts to align it properly :)

> > The co-processor supports a video progressing logic engine capable of
> > performing a variety of operations like image recovery, cropping,
> scaling,
> > gamma correction etc.
> >
> > Now, evaluating the framework available for supporting for the camera
> > host, sensor and co-processor, I am wondering whether soc-
> camera(v4l2) can
> > support this complex design or something similar to the ISP driver
> written
> > for OMAP is the way forward.
> 
> I think this can be a good candidate for the media controller API. It
> depends
> on how complex the co-processor is and what kind of processing it
> performs. I
> suppose there's no public datasheet.
> 
> You will probably need to enhance subdev registration, as I'm not aware
> of any
> existing use case such as yours where a chain of subdevs unknown to the
> host
> controller is connected to the host controller input.

Could you please give me some documentation links for media controller API.
Are there are reference drivers that I can use for my study?
Unfortunately the data-sheet of the co-processor cannot be made public
as of yet.

Regards,
Bhupesh
