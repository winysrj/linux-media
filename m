Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53247 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1C3Nb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2011 09:31:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: =?iso-8859-15?q?Lo=EFc_Akue?= <akue.loic@gmail.com>
Subject: Re: OMAP3 ISP and tvp5151 driver.
Date: Wed, 30 Mar 2011 15:32:16 +0200
Cc: Enric =?iso-8859-15?q?Balletb=F2_i_Serra?= <eballetbo@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com
References: <AANLkTimec2+VyO+iRSx1PYy3btOb6RbHt0j3ytmnykVo@mail.gmail.com> <201103292241.51237.laurent.pinchart@ideasonboard.com> <AANLkTikjDOsx6-A75A510k_BY0bF9qmTKKBw_YVyJgBF@mail.gmail.com>
In-Reply-To: <AANLkTikjDOsx6-A75A510k_BY0bF9qmTKKBw_YVyJgBF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103301532.16635.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Loïc,

On Wednesday 30 March 2011 13:05:08 Loïc Akue wrote:
> Hi Laurent,
> 
> > The OMAP3 ISP should support interleaving interlaced frames, but that's
> > not implemented in the driver. You will need to at least implement
> > interlaced frames support in the CCDC module to report field identifiers
> > to userspace.
> 
> Are you saying that the OMAP ISP could be configured to provide some full
> field frames on the CCDC output? I'm looking at the ISP's TRM but I can't
> find anything interesting.

Look at the "Line-Output Control" section in the OMAP3 TRM (SWPU177B, page 
1201).

> Or is it the job of the user space application to recompose the image with
> the interleaved frames?

-- 
Regards,

Laurent Pinchart
