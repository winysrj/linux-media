Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:55429 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546AbaGDHy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 03:54:59 -0400
Message-ID: <53B65DCA.6010803@xs4all.nl>
Date: Fri, 04 Jul 2014 09:54:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: No audio support in struct v4l2_subdev_format
References: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>
In-Reply-To: <BAY176-W7B3F24A204E68896226E0A9000@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/04/2014 08:49 AM, Divneil Wadhawan wrote:
> Hello,
> 
> 
> There's an HDMIRx subdev I have implemented and I would like the application to read properties of incoming audio.
> 
> For the moment, there's no support of it.
> 
> Can you share if some work is already done on this but not complete or we do it from scratch?

To my knowledge nobody has done much if any work on this. Usually the
audio part is handled by alsa, but it is not clear if support is also
needed from the V4L2 API. If such support is needed it will most likely
be in the form of a bunch of new controls.

Regards,

	Hans
