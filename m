Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35771 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291Ab0KQMfp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 07:35:45 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Shuzhen Wang" <shuzhenw@codeaurora.org>
Subject: Re: Question about setting V4L2_CID_AUTO_WHITE_BALANCE control to FALSE
Date: Wed, 17 Nov 2010 13:35:44 +0100
Cc: linux-media@vger.kernel.org
References: <000001cb85c4$981fdba0$c85f92e0$@org> <000301cb85de$642dd3f0$2c897bd0$@org>
In-Reply-To: <000301cb85de$642dd3f0$2c897bd0$@org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011171335.44876.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Tuesday 16 November 2010 23:34:11 Shuzhen Wang wrote:
> Nevermind. I think behavior #1 makes more sense.

I agree with that.

> On Tuesday, November 16, 2010 11:30 AM Shuzhen Wang wrote:
> > 
> > When I set V4L2_CID_AUTO_WHITE_BALANCE control to FALSE, which one of the
> > following is the expected behavior?
> > 
> > 1. Hold the current white balance settting.
> > 2. Set the white balance to whatever V4L2_CID_WHITE_BALANCE_TEMPERATURE
> > control is set to.
> > 
> > The V4L2 API spec doesn't specify this clearly.

The reason why the specification doesn't clearly state what must be done is 
that the behaviour might be hardware dependent. Some hardware won't offer 
option 1, so drivers will be forced to go for option 2.

(I'm not totally sure that's why the specification isn't clear about the 
expected behaviour, but it's at least a good justification for it :-))

-- 
Regards,

Laurent Pinchart
