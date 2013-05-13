Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4571 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3EMMOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 08:14:53 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4DCEo1t089209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 13 May 2013 14:14:52 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 4BFF71300054
	for <linux-media@vger.kernel.org>; Mon, 13 May 2013 14:14:44 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC] Support for events with a large payload
Date: Mon, 13 May 2013 14:14:43 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201305131414.43685.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the event API allows for a payload of up to 64 bytes. Sometimes we
would like to pass larger payloads to userspace such as metadata associated
with a particular video stream.

A typical example of that would be object detection events.

This RFC describes one approach for doing this.

The event framework has the nice property of being able to use from within
interrupts. Copying large payloads does not fit into that framework, so
such payloads should be adminstrated separately.

In addition, I wouldn't allow large payloads to be filled in from interrupt
context: a worker queue would be much more appropriate.

Note that the event API is only useful for relatively low-bandwidth data
since the data is always copied. When dealing with high-bandwidth data the
data should either be a separate plane or become a special stream I/O buffer
type.

The userspace API enhancements in order to achieve this would be the
following:

- Any event that has a large payload would specify a payload_sequence counter
  and a payload size value (in bytes).

- A new VIDIOC_DQEVENT_PAYLOAD ioctl would be added which passes the event type,
  the payload_sequence counter and a pointer to a buffer to the kernel, and the
  payload is returned, or an error is returned if the payload data is no longer
  available.

Optional enhancements:

- Have VIDIOC_SUBSCRIBE_EVENT return the maximum payload size (lets apps
  preallocate payload memory, but it might be overkill).

- Add functionality to VIDIOC_SUBSCRIBE_EVENT to define the number of
  events in the event queue for the filehandle. If the payload is large,
  you may want to limit the number of allocated payload buffers. For
  example: when dealing with metadata associated with frame you might want
  to limit the number of payload buffers to the number of allocated frames.

I feel that this can always be added later if we decide it is really needed,
and leave it out for now.

So the userspace API would be quite simple.

The internal implementation would look like this:

struct v4l2_event_payload {
	u32 payload_size;
	u32 payload_sequence;
	void *payload;
};

struct v4l2_event_payloads {
	// lock serializing access to this struct
	struct mutex lock;
	// global payload sequence number counter
	u32 payload_sequence;
	// size of the payload array
	unsigned payloads;
	// index of the oldest payload
	unsigned first;
	// number of payloads available
	unsigned in_use; 
	struct v4l2_event_payload payloads[];
};

and a pointer to struct v4l2_event_payloads would be added to struct
v4l2_subscribed_event.

It is up to the driver to decide whether there is one v4l2_event_payloads
struct per filehandle or whether there is a global struct shared by any
filehandle subscribed to this event. This will depend on the event and the
size of the payload. Most likely it will be the latter option (a global
queue of payloads).

Internal functions would look like this:

// Initialize the structs.
void v4l2_event_payloads_init(struct v4l2_event_payloads *p, unsigned payloads);
// Get the first available payload (the mutex must be locked). If no payloads
// are available then the oldest payload will be reused. A new sequence number
// will be generated as well.
struct v4l2_event_payload *v4l2_event_payloads_new(struct v4l2_event_payloads *p);
// Find the payload with the given sequence number. The mutex must be locked.
struct v4l2_event_payload *v4l2_event_payloads_find(struct v4l2_event_payloads *p, unsigned seqnr);

So when a new payload arrives the driver would take the mutex, call
v4l2_event_payloads_new(), set payload_size and fill the payload data,
remember the payload_size and payload_sequence values, release the mutex
and queue the event with the remembered size and sequence values. Setting
up the payload part cannot be done from interrupt context.

When calling DQEVENT_PAYLOAD the core will use the pointer to struct
v4l2_event_payloads from struct v4l2_subscribed_event, take the mutex,
find the payload, copy it to userspace and release the mutex.

Right now the mutex is in struct v4l2_event_payloads. This is not optimal:
it might be better to have a spinlock for controlling access to the
v4l2_event_payloads struct and a mutex for each v4l2_event_payload struct.
That way setting and getting two different payload structs wouldn't depend
on one another.

Comments?

	Hans

PS: I have no immediate plans to implement this, but based on recent discussions
it seems there is a desire to have support for this at some point in the future,
so I decided to see how this could be implemented.
