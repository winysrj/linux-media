Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:55522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab1B1LyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 06:54:24 -0500
Date: Mon, 28 Feb 2011 12:54:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
In-Reply-To: <201102281217.12538.hansverk@cisco.com>
Message-ID: <Pine.LNX.4.64.1102281237250.11156@axis700.grange>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange>
 <Pine.LNX.4.64.1102281148310.11156@axis700.grange>
 <201102281207.34106.laurent.pinchart@ideasonboard.com>
 <201102281217.12538.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 28 Feb 2011, Hans Verkuil wrote:

> Does anyone know which drivers stop capture if there are no buffers available? 
> I'm not aware of any.

Many soc-camera hosts do that.

> I think this is certainly a good initial approach.
> 
> Can someone make a list of things needed for flash/snapshot? So don't look yet 
> at the implementation, but just start a list of functionalities that we need 
> to support. I don't think I have seen that yet.

These are not the features, that we _have_ to implement, these are just 
the ones, that are related to the snapshot mode:

* flash strobe (provided, we do not want to control its timing from 
	generic controls, and leave that to "reasonable defaults" or to 
	private controls)
* trigger pin / command
* external exposure
* exposure mode (ERS, GRR,...)
* use "trigger" or "shutter" for readout
* number of frames to capture

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
