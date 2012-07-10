Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mlbassoc.com ([65.100.170.105]:47942 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2GJTbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 15:31:07 -0400
Message-ID: <4FFC82F9.2090004@mlbassoc.com>
Date: Tue, 10 Jul 2012 13:31:05 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: Chris Lalancette <clalancette@gmail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Discussion <linux-media@vger.kernel.org>,
	sergio.a.aguirre@gmail.com
Subject: Re: OMAP4 support
References: <4FFC3109.3080204@mlbassoc.com> <CABMb9GtV_CZ=ZFoqXD_u3dmZQoD5CmsptYkgwwecO7Ch9v3AAw@mail.gmail.com>
In-Reply-To: <CABMb9GtV_CZ=ZFoqXD_u3dmZQoD5CmsptYkgwwecO7Ch9v3AAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2012-07-10 11:05, Chris Lalancette wrote:
> On Tue, Jul 10, 2012 at 9:41 AM, Gary Thomas <gary@mlbassoc.com> wrote:
>> I'm looking for video support on OMAP4 platforms.  I've found the
>> PandaBoard camera project
>> (http://www.omappedia.org/wiki/PandaBoard_Camera_Support)
>> and this is starting to work.  That said, I'm having some
>> issues with setting up the pipeline, etc.
>>
>> Can this list help out?
>
> I'm not sure exactly what kind of cameras you want to get working, but
> if you are looking to get CSI2 cameras going through the ISS, Sergio
> Aguirre has been working on support.  He also works on the media-ctl
> tool, which is used for configuring the media framework pipeline.  The
> latest versions that I am aware of are here:
>
> git://gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera.git

Yes, this is the tree I've been working with (pointed to by the page I mentioned).

My kernel can see the camera OV5650 and set up the pipeline.  I am able to grab
the raw SGRBG10 data but I'd like to get the ISS to convert this to a more usable
UYVY format.  Here's what I tried:
   media-ctl -r
   media-ctl -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS ISP IPIPEIF":0 [1]'
   media-ctl -l '"OMAP4 ISS ISP IPIPEIF":1 -> "OMAP4 ISS ISP IPIPEIF output":0 [1]'
   media-ctl -f '"ov5650 3-0036":0 [SGRBG10 2592x1944]'
   media-ctl -f '"OMAP4 ISS CSI2a":0 [SGRBG10 2592x1944]'
   media-ctl -f '"OMAP4 ISS ISP IPIPEIF":0 [SGRBG10 2592x1944]','"OMAP4 ISS ISP IPIPEIF":1 [UYVY 2592x1944]'

Sadly, I can't get the IPIPEIF element to take SGRGB10 in and put UYVY out (my reading
of the manual implies that this _should_ be possible).  I always see this pipeline setup:
- entity 5: OMAP4 ISS ISP IPIPEIF (3 pads, 4 links)
             type V4L2 subdev subtype Unknown
             device node name /dev/v4l-subdev2
         pad0: Input [SGRBG10 2592x1944]
                 <- 'OMAP4 ISS CSI2a':pad1 [ACTIVE]
                 <- 'OMAP4 ISS CSI2b':pad1 []
         pad1: Output [SGRBG10 2592x1944]
                 -> 'OMAP4 ISS ISP IPIPEIF output':pad0 [ACTIVE]
         pad2: Output [SGRBG10 2592x1944]
                 -> 'OMAP4 ISS ISP resizer':pad0 []

Am I missing something?  How can I make this conversion in the ISS?

Note: if this is not the appropriate place to ask these questions, please
redirect me (hopefully to a useful list :-)

Thanks

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------


