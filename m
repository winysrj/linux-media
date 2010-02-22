Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:39721 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab0BVWsB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 17:48:01 -0500
Message-ID: <4B830995.1090903@maxwell.research.nokia.com>
Date: Tue, 23 Feb 2010 00:47:49 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	david.cohen@nokia.com
Subject: Re: [PATCH 6/6] V4L: Events: Add documentation
References: <4B82A7FB.50505@maxwell.research.nokia.com> <1266853897-25749-5-git-send-email-sakari.ailus@maxwell.research.nokia.com> <1266853897-25749-6-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201002222057.24236.hverkuil@xs4all.nl>
In-Reply-To: <201002222057.24236.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> +  <para>To receive events, the events the user is interested first
>> +  must be subscribed using the &VIDIOC-SUBSCRIBE-EVENT; ioctl. Once an
>> +  event is subscribed, the events of subscribed types are dequeueable
>> +  using the &VIDIOC-DQEVENT; ioctl. Events may be unsubscribed using
>> +  VIDIOC_UNSUBSCRIBE_EVENT ioctl. The special event type
>> +  V4L2_EVENT_ALL may be used to subscribe or unsubscribe all the
> 
> ALL may be used only with unsubscribe.

Missed that one. Thanks.

...
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>type</structfield></entry>
>> +	    <entry>Type of the event.</entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry>__u32</entry>
>> +	    <entry><structfield>reserved</structfield>[7]</entry>
>> +	    <entry>Reserved for future extensions. Drivers must set
> 
> Drivers and applications must zero this array.

Fixed.

>> +	    the array to zero.</entry>
>> +	  </row>
>> +	</tbody>
>> +      </tgroup>
>> +    </table>
>> +
>> +    <table frame="none" pgwide="1" id="event-type">
>> +      <title>Event Types</title>
>> +      <tgroup cols="3">
>> +	&cs-def;
>> +	<tbody valign="top">
>> +	  <row>
>> +	    <entry><constant>V4L2_EVENT_ALL</constant></entry>
>> +	    <entry>0</entry>
>> +	    <entry>All events. V4L2_EVENT_ALL is valid only for
>> +	    VIDIOC_UNSUBSCRIBE_EVENT for unsubscribing all events at once.
>> +	    </entry>
>> +	  </row>
>> +	  <row>
>> +	    <entry><constant>V4L2_EVENT_PRIVATE_START</constant></entry>
>> +	    <entry>0x08000000</entry> <entry></entry>
> 
> This needs a short description. E.g.: 'Base event number for driver-private events.'

Added.

...

>> +Drivers do not initialise events directly. The events are initialised
>> +through v4l2_fh_init() if video_device->ioctl_ops->vidioc_subscribe_event is
>> +non-NULL. This *MUST* be performed in the driver's
>> +v4l2_file_operations->open() handler.
>> +
>> +Events are delivered to user space through the poll system call. The driver
>> +can use v4l2_fh->events->wait wait_queue_head_t as the argument for
>> +poll_wait().
>> +
>> +There are standard and private events. New standard events must use the
>> +smallest available event type. The drivers must allocate their events
>> +starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) while individual
>> +events start from base + 1.
> 
> What do you mean with 'while individual events start from base + 1'? I still
> don't understand that phrase.

Will be "There are standard and private events. New standard events must
use the smallest available event type. The drivers must allocate their
events starting from base (V4L2_EVENT_PRIVATE_START + n * 1024) + 1." in
the next one.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
