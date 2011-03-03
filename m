Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45217 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451Ab1CCSoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 13:44:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?iso-8859-15?q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Subject: Re: Demande de support V4L2
Date: Thu, 3 Mar 2011 19:44:20 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTinK1MvhNtAKpSwMARZhLNrW+FGLwd9KMcbdwOCa@mail.gmail.com> <201103031838.45988.laurent.pinchart@ideasonboard.com> <AANLkTim_z4NBeuG_s-OzY-JkfbH8pxG2d-ag8i-muDjV@mail.gmail.com>
In-Reply-To: <AANLkTim_z4NBeuG_s-OzY-JkfbH8pxG2d-ag8i-muDjV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103031944.20744.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Loïc,

On Thursday 03 March 2011 18:51:21 Loïc Akue wrote:
> Thanks you for the reply,
> 
> I already tried to contact the mailing list, but I didn't get the help
> expected =s I get I just be patient, and keep on trying.
> 
> So, according to your answer, the CCDC should be able to provide some YUV
> data, that I can get on the /dev/video2 node, using the yavta application.
> Correct me if I'm wrong.

The CCDC is able to handle both YUV and raw Bayer data. YUV data can be saved 
to memory through the CCDC output video node or forwarded to the resizer. Raw 
Bayer data can be saved to memory or forwarded to the preview engine.

YUV support for the CCDC module is not implemented yet in the ISP driver. The 
CCDC to resizer link hasn't been tested.

8-bit grey data is supported by the ISP driver. It's currently considered by 
the CCDC as raw Bayer data. As the CCDC doesn't perform Bayer to YUV 
conversion, you can save 8-bit grey data to memory at the CCDC output. 
Forwarding 8-bit grey data to the preview engine will work but will produce 
weird results as the preview engine will process it as raw Bayer data.

-- 
Regards,

Laurent Pinchart
