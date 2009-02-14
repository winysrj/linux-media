Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2001 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbZBNXWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 18:22:18 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: libv4l2 library problem
Date: Sun, 15 Feb 2009 00:22:20 +0100
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <200902131357.46279.hverkuil@xs4all.nl>
In-Reply-To: <200902131357.46279.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902150022.20486.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 13 February 2009 13:57:45 Hans Verkuil wrote:
> Hi Hans,
>
> I've developed a converter for the HM12 format (produced by Conexant MPEG
> encoders as used in the ivtv and cx18 drivers).
>
> But libv4l2 has a problem in its implementation of v4l2_read: it assumes
> that the driver can always do streaming. However, that is not the case
> for some drivers, including cx18 and ivtv. These drivers only implement
> read() functionality and no streaming.
>
> Can you as a minimum modify libv4l2 so that it will check for this case?
> The best solution would be that libv4l2 can read HM12 from the driver and
> convert it on the fly. But currently it tries to convert HM12 by starting
> to stream, and that produces an error.
>
> This bug needs to be fixed first before I can contribute my HM12
> converter.

My sincere apologies: I looked at the libv4l2 code again and it was clear 
that it did in fact test for this case. I retested my own code and 
everything seems to work as it should. So libv4l2 is fine, and I will 
prepare a tree tomorrow containing the hm12 support for libv4lconvert.

Sorry about this,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
