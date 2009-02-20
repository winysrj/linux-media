Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:11078 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZBTJtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2009 04:49:49 -0500
Date: Fri, 20 Feb 2009 10:49:35 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	urishk@yahoo.com, linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090220104935.0c516a57@hyperion.delvare>
In-Reply-To: <200902200753.16856.hverkuil@xs4all.nl>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<20090218140105.17c86bcb@hyperion.delvare>
	<1235102231.2708.19.camel@pc10.localdom.local>
	<200902200753.16856.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Feb 2009 07:53:16 +0100, Hans Verkuil wrote:
> On Friday 20 February 2009 04:57:11 hermann pitton wrote:
> > Hans decided deliberately to extend backward compat even down to 2.6.16,
> > now seeing the bill.
> 
> I didn't extend it, instead I reduced the backward compat to 2.6.16 at the 
> time. It supported older kernels as well back then, however since nobody 
> ever compiled for those older kernels quite a few drivers were broken.
> 
> Creating the daily build system at least ensures that we know v4l-dvb can 
> compile for those kernels we support officially. In the past this was more 
> based on hope and a prayer :-)

That's better than before, but just because it builds doesn't mean it
works...

-- 
Jean Delvare
