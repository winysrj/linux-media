Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:56704 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab1B1MDK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 07:03:10 -0500
Date: Mon, 28 Feb 2011 14:03:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Message-ID: <20110228120304.GA25250@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <201102281140.31643.hansverk@cisco.com>
 <Pine.LNX.4.64.1102281148310.11156@axis700.grange>
 <201102281207.34106.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102281220590.11156@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1102281220590.11156@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 28, 2011 at 12:37:06PM +0100, Guennadi Liakhovetski wrote:
> So, you'd also need a separate control for external exposure, there are 
> also sensors, that can be configured to different shutter / exposure / 
> readout sequence controlling... No, we don't have to support all that 
> variety, but we have to be aware of it, while making decisions;)

Hi Guennadi,

Do you mean that there are sensors that can synchronise these parameters at
frame level, or how? There are use cases for that but it doesn't limit to
still capture.

Are there any public datasheets that you know of on these?

Regards,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
