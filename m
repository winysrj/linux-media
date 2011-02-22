Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:38419 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520Ab1BVPeq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Feb 2011 10:34:46 -0500
Message-ID: <4D63D78E.3070000@mm-sol.com>
Date: Tue, 22 Feb 2011 17:34:38 +0200
From: Stan <svarbanov@mm-sol.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, saaguirre@ti.com
Subject: Re: [RFC/PATCH 0/1] New subdev sensor operation g_interface_parms
References: <cover.1298368924.git.svarbanov@mm-sol.com> <Pine.LNX.4.64.1102221215350.1380@axis700.grange> <201102221432.50847.hansverk@cisco.com> <Pine.LNX.4.64.1102221456590.1380@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102221456590.1380@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Guennadi Liakhovetski wrote:
> On Tue, 22 Feb 2011, Hans Verkuil wrote:
> 
>> On Tuesday, February 22, 2011 12:40:32 Guennadi Liakhovetski wrote:
>>> On Tue, 22 Feb 2011, Stanimir Varbanov wrote:
>>>
>>>> This RFC patch adds a new subdev sensor operation named g_interface_parms.
>>>> It is planned as a not mandatory operation and it is driver's developer
>>>> decision to use it or not.
>>>>
>>>> Please share your opinions and ideas.
>> Stanimir, thanks for the RFC. I think it is time that we create a good 
>> solution for this. This is currently the last remaining issue preventing soc-
>> camera subdevs from being used generally. (Control handling is also still 
>> special, but this is being worked on.)
>>
>>> Yes, I like the idea in principle (/me pulling his bullet-proof vest on), 
>> :-)
>>
>>> as some of you might guess, because I feel it's going away from the idea, 
>>> that I've been hard pressed to accept of hard-coding the media-bus 
>>> configuration and in the direction of direct communication of 
>>> bus-parameters between the (sub-)devices, e.g., a camera host and a camera 
>>> device in soc-camera terminology.
>>>
>>> But before reviewing the patch as such, I'd like to discuss the strategy, 
>>> that we want to pursue here - what exactly do we want to hard-code and 
>>> what we want to configure dynamically? As explained before, my preference 
>>> would be to only specify the absolute minimum in the platform data, i.e., 
>>> parameters that either are ambiguous or special for this platform. So, 
>>> once again, my approach to configure interface parameters like signal 
>>> polarities and edge sensitivity is:
>>>
>>> 1. if at least one side has a fixed value of the specific parameter, 
>>> usually no need to specify it in platform data. Example: sensor only 
>>> supports HSYNC active high, host supports both, normally "high" should be 
>>> selected.
>>>
>>> 2. as above, but there's an inverter on the board in the signal path. The 
>>> "invert" parameter must be specified in the platform data and the host 
>>> will configure itself to "low" and send "high" confirmed to the sensor.
>>>
>>> 3. both are configurable. In this case the platform data has to specify, 
>>> which polarity shall be used.
>>>
>>> This is simple, it is implemented, it has worked that way with no problem 
>>> for several years now.
>>>
>>> The configuration procedure in this case looks like:
>>>
>>> 1. host requests supported interface configurations from the client 
>>> (sensor)
>>>
>>> 2. host matches returned parameters against platform data and its own 
>>> capabilities
>>>
>>> 3. if no suitable configuration possible - error out
>>>
>>> 4. the single possible configuration is identified and sent to the sensor 
>>> back for its configuration
>>>
>>> This way we need one more method: s_interface_parms.
>>>
>>> Shortly talking to Laurent earlier today privately, he mentioned, that one 
>>> of the reasons for this move is to support dynamic bus reconfiguration, 
>>> e.g., the number of used CSI lanes. The same is useful for parallel 
>>> interfaces. E.g., I had to hack the omap3spi driver to capture only 8 
>>> (parallel) data lanes from the sensor, connected with all its 10 lanes to 
>>> get a format, easily supported by user-space applications. Ideally you 
>>> don't want to change anything in the code for this. If the user is 
>>> requesting the 10-bit format, all 10 lanes are used, if only 8 - the 
>>> interface is reconfigured accordingly.
>> I have no problems with dynamic bus reconfiguration as such. So if the host 
>> driver wants to do lane reconfiguration, then that's fine by me.
>>
>> When it comes to signal integrity (polarity, rising/falling edge), then I 
>> remain convinced that this should be set via platform data. This is not 
>> something that should be negotiated since this depends not only on the sensor 
>> and host devices, but also on the routing of the lines between them on the 
>> actual board, how much noise there is on those lines, the quality of the clock 
>> signal, etc. Not really an issue with PAL/NTSC type signals, but when you get 
>> to 1080p60 and up, then such things become much more important.
> 

I think this could be satisfied by Guennadi's approach because he use the
platform data with preference.

> I understand this, but my point is: forcing this parameters in the 
> platform data doesn't give you any _practical_ enhancements, only 
> _psychological_, meaning, that you think, that if these parameters are 
> compulsory, programmers, writing board integration code, will be forced to 
> think, what values to configure. Whereas if this is not compulsory, 
> programmers will hope on automagic and things will break. So, this is 
> purely psychological. And that's the whole question - fo we trust 
> programmers, that they will anyway take care to set correct parameters, or 
> do we not trust them and therefore want to punish everyone because of 
> them. Besides, I'm pretty convinced, that even if those parameters will be 
> compulsory, most programmers will anyway just copy-paste them from 
> "similar" set ups...
> 

Guennadi, IMO, to force peoples to __not__ thinking about the above parameter
configurations you need to do generic functions in some place and force
peoples to use them as mandatory rule. This will be the hard part :)

In principle I agree with this bus negotiation.

 - So. let's start thinking how this could be fit to the subdev sensor
operations.
 - howto isolate your current work into some common place and reuse it,
even on platform part.
 - and is it possible.

The discussion becomes very emotional and this is not a good adviser :)

> Thanks
> Guennadi
> 
>> So these settings should not be negotiated, but set explicitly.
>>
>> It actually doesn't have to be done through platform data (although that makes 
>> the most sense), as long as it is explicitly set based on board-specific data.
>>

<snip>

-- 
Best regards,
Stan
