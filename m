Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58948 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1BWQg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 11:36:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
Date: Wed, 23 Feb 2011 17:37:06 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	saaguirre@ti.com
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102230910.43069.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102231737.06421.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Wednesday 23 February 2011 10:31:21 Guennadi Liakhovetski wrote:

[snip]

> Currently soc-camera auto-configures the following parameters:
> 
> hsync polarity
> vsync polarity
> data polarity

Data polarity ? Are there sensors that can invert the data polarity ?

> master / slave mode
> data bus width
> pixel clock polarity

-- 
Regards,

Laurent Pinchart
