Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19058 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab0CQOaB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 10:30:01 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZF009EUK9Z6S80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:29:59 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZF0063UK9YCV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 14:29:59 +0000 (GMT)
Date: Wed, 17 Mar 2010 15:29:48 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH/RFC 0/2] Fix DQBUF behavior for recoverable streaming errors
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1268836190-31051-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

during the V4L2 brainstorm meeting in Norway we have concluded that streaming
error handling in dqbuf is lacking a bit and might result in the application
losing video buffers.

V4L2 specification states that DQBUF should set errno to EIO in such cases:


"EIO

VIDIOC_DQBUF failed due to an internal error. Can also indicate temporary
problems like signal loss. Note the driver might dequeue an (empty) buffer
despite returning an error, or even stop capturing."

There is a problem with this though. v4l2-ioctl.c code does not copy back
v4l2_buffer fields to userspace on a failed ioctl invocation, i.e. when
__video_do_ioctl() does not return 0, it jumps over the copy_to_user()
code:

/* ... */
err = __video_do_ioctl(file, cmd, parg);
/* ... */
if (err < 0)
	goto out;
/* ... */
	if (copy_to_user((void __user *)arg, parg, _IOC_SIZE(cmd)))
		err = -EFAULT;
/* ... */
out:


This is fine in general, but in the case of DQBUF errors, the v4l2_buffer
fields are not copied back. Because of that, the application does not have any
means of discovering on which buffer the operation failed. So it cannot reuse
that buffer, even despite the fact that the spec allows such behavior.


This RFC proposes a modification to the DQBUF behavior in cases of internal
(recoverable) errors to allow recovery from such situations.

We propose a new flag for the v4l2_buffer "flags" field, "V4L2_BUF_FLAG_ERROR".
There already exists a "V4L2_BUF_FLAG_DONE" flag, so to support older
applications, the new flag should always be set together with it.

Applications unaware of the new flag would simply display a corrupted frame, but
we believe it is still a better solution than failing altogether. Old EIO
behavior remains so the change is backwards compatible.

I will post relevant V4L2 documentation updates after (if) this change is 
accepted.


This series is rebased onto my recent videobuf clean-up and poll behavior
patches.

The series contains:
[PATCH 1/2] v4l: Add a new ERROR flag for DQBUF after recoverable streaming errors
[PATCH 2/2] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
