Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49133 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab1CAJkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 04:40:52 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Subject: Re: isp or soc-camera for image co-processors
Date: Tue, 1 Mar 2011 10:41:03 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384DEFA5983D@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011041.03424.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bhupesh,

On Tuesday 01 March 2011 08:25:12 Bhupesh SHARMA wrote:
> Hi Guennadi and Laurent,
> 
> We are now evaluating another ST platform that supports a image
> co-processor between the camera sensor and the camera host (SoC).
> 
> The simple architecture diagram will be similar to one shown below
> (for the sake of simplicity I show only a single sensor. At least
> two sensors can be supported by the co-processor):

[snip] (as the ascii-art looks more like a Picasso painting with the quote 
characters)

> The co-processor supports a video progressing logic engine capable of
> performing a variety of operations like image recovery, cropping, scaling,
> gamma correction etc.
> 
> Now, evaluating the framework available for supporting for the camera
> host, sensor and co-processor, I am wondering whether soc-camera(v4l2) can
> support this complex design or something similar to the ISP driver written
> for OMAP is the way forward.

I think this can be a good candidate for the media controller API. It depends 
on how complex the co-processor is and what kind of processing it performs. I 
suppose there's no public datasheet.

You will probably need to enhance subdev registration, as I'm not aware of any 
existing use case such as yours where a chain of subdevs unknown to the host 
controller is connected to the host controller input.

> Any pointers on the same and reference links to some documentation
> will be highly appreciated.

-- 
Regards,

Laurent Pinchart
