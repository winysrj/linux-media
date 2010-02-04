Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:21467 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0BDOWZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2010 09:22:25 -0500
Message-ID: <4B6AD7E3.6020102@maxwell.research.nokia.com>
Date: Thu, 04 Feb 2010 16:21:23 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap34xxcam question?
References: <4B4F0762.4040007@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com> <4B4F537B.7000708@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539065@dlee02.ent.ti.com> <4B4F56C8.7060108@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539623@dlee02.ent.ti.com> <4B502982.4050508@panicking.kicks-ass.org>
In-Reply-To: <4B502982.4050508@panicking.kicks-ass.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

Michael Trimarchi wrote:
> Aguirre, Sergio wrote:
...
>> So, if I got you right, you're saying that, there should be priorities
>> for sensor baseformats, depending on the preference specified
>> somewhere in the boardfile?
> 
> Yes, that is the idea. Try to provide a better patch later, I'm working
> hard on the sensor part :)

Apologies for my late answer.

The frame sizes in our sensor drivers are in width descending order. The
selection has been working somehow so far but it's definitely not perfect.

We're converting the ISP driver to use the Media controller so this code
will be dropped in near future probably. In that case the user space has
to select the sensor mode it wants to use as well.

Regular V4L2 applications of course cannot be expected to do that. But
it probably should be handled in user space (i.e. libv4l) or by offering
a dummy video node that just produces some kind of images.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
