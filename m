Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48150 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018AbbGNHwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2015 03:52:42 -0400
Message-ID: <55A4BF6B.2070106@xs4all.nl>
Date: Tue, 14 Jul 2015 09:51:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Bjornar Salberg <bsalberg@cisco.com>
Subject: Re: [RFC] How to get current position/status of iris/focus/pan/tilt/zoom?
References: <559527D7.1030408@xs4all.nl> <2062145.8YAJ1MQW9W@avalon>
In-Reply-To: <2062145.8YAJ1MQW9W@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/08/15 13:25, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 02 July 2015 14:00:23 Hans Verkuil wrote:
>> When using V4L2_CID_IRIS/FOCUS/PAN/TILT/ZOOM_ABSOLUTE/RELATIVE, how do you
>> know when the new position has been reached? If this is controlled through
>> a motor, then it may take some time and ideally you would like to be able
>> to get the current absolute position (if the hardware knows) and whether
>> the final position has been reached or not.
> 
> There's only two drivers implementing pan and tilt (pwc and uvcvideo), one 
> driver implementing focus and iris (uvcvideo) and three drivers implementing 
> zoom (uvcvideo, m5mols and s5c73m3). Both m5mols and s5c73m3 seem to use the 
> zoom control for digital zoom, so we can ignore them for this discussion. 
> Where's thus left with pwc and uvcvideo. I'll comment mainly on the latter.
> 
>> In addition, it should be possible to raise fault conditions.
> 
> UVC specifies a way to implement asynchronous controls and report, through a 
> USB interrupt endpoint, completion of the control set operation. This can be 
> used by devices to report that physical motion has finished, or to report 
> errors. Whether a control is implemented in a synchronous or asynchronous way 
> is device dependent.
> 
>> The way the ABSOLUTE controls are defined is ambiguous since it doesn't say
>> anything about what it returns when you read it: is that the current
>> absolute position, or the last set absolute position? I suspect it is the
>> second one.
>>
>> If it is the second one, then I propose a V4L2_CID_IRIS_CURRENT control (and
>> ditto for the other variants) that is a read-only control returning the
>> current position with the same range and unit as the ABSOLUTE control.
> 
> UVC doesn't explicitly define what a device should report. It hints in a 
> couple of places that it should be the current position, but I believe it 
> might be device-dependent in practice.

What does the uvc driver do today when an application asks for the IRIS_ABSOLUTE
value? Does it pass that request on to the webcam or does it return the last
set value?

We can choose to have the control type determine what the control does:

if it is just a normal integer control, then it returns the last set value. If
the hardware can return the current position, then it can set the new
V4L2_CTRL_FLAG_EXECUTE_ON_WRITE flag, which means that when you read it you get
the actual position, and when you write it you set the desired position.

But I don't know if the UVC driver can use this. I guess from your description
that it can determine this based on whether the control is synchronous or
asynchronous.

>> For the status/fault information I think the V4L2_CID_AUTO_FOCUS_STATUS
>> comes close, but it is too specific for auto focus. For manually
>> positioning things this might be more suitable:
>>
>> V4L2_CID_IRIS_STATUS	bitmask
>>
>> 	V4L2_IRIS_STATUS_MOVING (or perhaps _BUSY?)
>> 	V4L2_IRIS_STATUS_FAILED
>>
>> And ditto for the other variants.
> 
> Do we need to report that the control set operation is in progress, or could 
> applications infer that information from the fact that they haven't received a 
> control change event that notifies of end of motion ?

You do need some sort of 'in progress' control or status. You don't want to
require applications to check control change events for the new value and compare
it to the end-value to determine if it is moving. And you can't use that anyway
if an error occurs that forces the motor to stop moving before the final position
has been reached.

> 
> Failures need to be reported, but they're not limited to the controls you 
> mention above, at least in theory. A UVC device is free to implement any 
> control as an asynchronous control and report failures. Would it make sense to 
> add a control change error event instead of creating status controls for lots 
> of V4L2 controls ?

Hmm, interesting, need to think about this.

Question: when you set an asynchronous uvc control, does it report back that
the new value was set OK, or does it only report back errors? And what sort
of errors are defined?

Regards,

	Hans
