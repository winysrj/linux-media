Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:62678 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab1BYSXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 13:23:55 -0500
Message-ID: <4D67F3AF.7060808@maxwell.research.nokia.com>
Date: Fri, 25 Feb 2011 20:23:43 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
References: <cover.1298368924.git.svarbanov@mm-sol.com> <201102221800.49914.hverkuil@xs4all.nl> <4D642DE2.3090705@gmail.com> <201102230910.43069.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102231020330.8880@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi and others,

Apologies for the late reply...

Guennadi Liakhovetski wrote:
> On Wed, 23 Feb 2011, Hans Verkuil wrote:
> 
>> On Tuesday, February 22, 2011 22:42:58 Sylwester Nawrocki wrote:
>>> Clock values are often being rounded at runtime and do not always reflect exactly
>>> the numbers fixed at compile time. And negotiation could help to obtain exact
>>> values at both sensor and host side.
>>
>> The only static data I am concerned about are those that affect signal integrity.
>> After thinking carefully about this I realized that there is really only one
>> setting that is relevant to that: the sampling edge. The polarities do not
>> matter in this.
> 
> Ok, this is much better! I'm still not perfectly happy having to punish 
> all just for the sake of a couple of broken boards, but I can certainly 
> much better live with this, than with having to hard-code each and every 
> bit. Thanks, Hans!

How much punishing would actually take place without autonegotiation?
How many boards do we have in total? I counted around 26 of
soc_camera_link declarations under arch/. Are there more?

An example of hardware which does care about clock polarity is the
N8[01]0. The parallel clock polarity is inverted since this actually
does improve reliability. In an ideal hardware this likely wouldn't
happen but sometimes the hardware is not exactly ideal. Both the sensor
and the camera block support non-inverted and inverted clock signal.

So at the very least it should be possible to provide this information
in the board code even if both ends share multiple common values for
parameters.

There have been many comments on the dangers of the autonegotiation and
I share those concerns. One of my main concerns is that it creates an
unnecessary dependency from all the boards to the negotiation code, the
behaviour of which may not change.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
