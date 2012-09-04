Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:3722 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab2IDKiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2012 06:38:09 -0400
Received: from cobaltpc1.localnet (dhcp-10-54-92-107.cisco.com [10.54.92.107])
	by ams-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id q84Ac7Nf006971
	for <linux-media@vger.kernel.org>; Tue, 4 Sep 2012 10:38:07 GMT
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: use of timestamp/sequence in v4l2_buffer
Date: Tue, 4 Sep 2012 12:38:06 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209041238.07000.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

During the Media Workshop last week we discussed how the timestamp and sequence
fields in struct v4l2_buffer should be used.

While trying to document the exact behavior I realized that there are a few
missing pieces.

Open questions with regards to the sequence field:

1) Should the first frame that was captured or displayed after starting streaming
for the first time always start with sequence index 0? In my opinion it should.

2) Should the sequence counter be reset to 0 after a STREAMOFF? Or should it only
be reset to 0 after REQBUFS/CREATE_BUFS is called?

3) Should the sequence counter behave differently for mem2mem devices? With the
current definition both the capture and display sides of a mem2mem device just have
their own independent sequence counter.

4) If frames are skipped, should the sequence counter skip as well? In my opinion
it shouldn't.

5) Should the sequence counter always be monotonically increasing? I think it should.

Open questions with regards to the timestamp field:

6) For output devices the timestamp field can be used to determine when to transmit
the frame. In practice there are no output drivers that support this. It is also
unclear how this would work: if the timestamp is 1 hour into the future, should the
driver hold on to that frame for one hour? If another frame is queued with a timestamp
that's earlier than the previous frame, should that frame be output first?

I am inclined to drop this behavior from the spec. Should we get drivers that actually
implement this, then we need to clarify the spec and add a new capability flag somewhere
to tell userspace that you can actually use the timestamp for this purpose.

7) Should the timestamp field always be monotonically increasing? Or it is possible
to get timestamps that jump around? This makes sense for encoders that create B-frames
referring to frames captured earlier than an I-frame.

8) How should the timestamp field be handled for mem2mem devices? Setting the timestamp
is pointless for the display side of a mem2mem device (as discussed above as well).
One option is that the mem2mem driver sets the timestamp when it starts processing a
queued frame. This timestamp is returned when the buffer is dequeued. This timestamp
is also copied to the processed frame (on the capture side of the mem2mem device),
thus allowing one to relate the captured processed frame to the source frame.

Even if encoder devices rearrange the frames (as discussed in the previous point),
the timestamp can still be used to map the frames.

Comments are welcome!

Regards,

	Hans
