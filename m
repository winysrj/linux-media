Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:53750 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbZJBMh1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Oct 2009 08:37:27 -0400
Message-ID: <4AC5F3F7.4010404@maxwell.research.nokia.com>
Date: Fri, 02 Oct 2009 15:37:11 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dqbuf in blocking mode
References: <A24693684029E5489D1D202277BE89444C9C902B@dlee02.ent.ti.com> <200910011534.28019.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910011534.28019.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
[clip]
> If I'm not mistaken videobuf_dqbuf() only returns -EIO if the buffer state is 
> VIDEOBUF_ERROR. This is the direct result of either
> 
> - videobuf_queue_cancel() being called, or
> - the device driver marking the buffer as erroneous because of a (possibly 
> transient) device error
> 
> In the first case VIDIOC_DQBUF should in my opinion return with an error. In 
> the second case things are not that clear. A transient error could be hidden 
> from the application, or, if returned to the application through -EIO, 
> shouldn't be treated as a fatal error. Non-transient errors should result in 
> the application stopping video streaming.
> 
> Unfortunately there V4L2 API doesn't offer a way to find out if the error is 
> transient or fatal:
> 
> "EIO		VIDIOC_DQBUF failed due to an internal error. Can also indicate 
> temporary problems like signal loss. Note the driver might dequeue an (empty) 
> buffer despite returning an error, or even stop capturing."
> 
> -EIO can mean many different things that need to be handled differently by 
> applications. I especially hate the "the driver might dequeue an (empty) 
> buffer despite returning an error".
> 
> Drivers should always or never dequeue a buffer when an error occurs, not 
> sometimes. The problem is for the application to recognize the difference 
> between a transient and a fatal error in a backward-compatible way.

The errors in this case are transient and for blocking mode IMO the 
safest way is to return the buffer only when there's one available. 
Which is what the driver is doing now.

What I'd probably change, however, is to move the handling to the ISP 
driver instead.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
