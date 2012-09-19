Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:13392 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2ISI7h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 04:59:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Questions regarding vb2 and multiplanar support
Date: Wed, 19 Sep 2012 10:59:23 +0200
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209191059.23319.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm working on adding multiplanar support to v4l2-ctl, but I have a few questions.

First of all, when I call QUERYBUF I set the length field of v4l2_buffer to the
number of elements in my v4l2_plane array.

When QUERYBUF returns, shouldn't the length field be updated to the actual number
of planes? Right now it remains unchanged which was somewhat surprising to me.

Since the length isn't updated, can you walk over the planes and detect which are
valid and which aren't? The documentation is very vague.

Is anyone relying on the current behavior or could it be changed? It would actually
make __fill_v4l2_buffer() more efficient since currently it is copying as many
v4l2_planes as possible, when it only needs to copy num_planes.

The second question is that it seems that for multiplanar support you must setup
the pointer to the v4l2_plane array, otherwise __verify_planes_array() returns
an error. What is scary is that __fill_v4l2_buffer() calls __verify_planes_array(),
but often the error code of __fill_v4l2_buffer() is not checked. So if DQBUF
is called without a proper pointer, then it seems to work, but in reality struct
v4l2_buffer isn't filled in.

__verify_planes_array() should be called before __fill_v4l2_buffer() is called,
rather than inside that function.

Comments?

	Hans
