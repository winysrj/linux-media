Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32950 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1CJRzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 12:55:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?iso-8859-15?q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Subject: Re: Demande de support V4L2
Date: Thu, 10 Mar 2011 18:56:06 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTinK1MvhNtAKpSwMARZhLNrW+FGLwd9KMcbdwOCa@mail.gmail.com> <201103031944.20744.laurent.pinchart@ideasonboard.com> <AANLkTi=K9hxzFgPgVaLw-JZBs8gPAcG2mHqJoTGXLF0O@mail.gmail.com>
In-Reply-To: <AANLkTi=K9hxzFgPgVaLw-JZBs8gPAcG2mHqJoTGXLF0O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103101856.07175.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Loïc,

On Thursday 10 March 2011 18:07:52 Loïc Akue wrote:
> Hi Linux, Media.
> 
> I'd like you to help me understand how the yavta application uses the
> omap3isp interrupts to capture some frames please.

Applications don't "use" the OMAP3 ISP interrupts. They interface with the 
driver through the MC and V4L2 APIs. The OMAP3 ISP driver handles the 
interrupts internally.

> When I use the yavta application to capture raw data from the CCDC output,
> the system hangs. I reduced the numbers of lines to reach, to generate the
> VD0 interrupt, but I still can get any images.

-- 
Regards,

Laurent Pinchart
