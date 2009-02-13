Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1806 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZBMM5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2009 07:57:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: libv4l2 library problem
Date: Fri, 13 Feb 2009 13:57:45 +0100
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902131357.46279.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I've developed a converter for the HM12 format (produced by Conexant MPEG 
encoders as used in the ivtv and cx18 drivers).

But libv4l2 has a problem in its implementation of v4l2_read: it assumes 
that the driver can always do streaming. However, that is not the case for 
some drivers, including cx18 and ivtv. These drivers only implement read() 
functionality and no streaming.

Can you as a minimum modify libv4l2 so that it will check for this case? The 
best solution would be that libv4l2 can read HM12 from the driver and 
convert it on the fly. But currently it tries to convert HM12 by starting 
to stream, and that produces an error.

This bug needs to be fixed first before I can contribute my HM12 converter.

A second question is if it is possible to let the code conform to 
checkpatch? A tabsize of 2 is rather hard to read IMHO. And it avoids the 
checkpatch errors as well when you do a make commit. I'm willing to do a 
pass over the code to clean it up if you want.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
