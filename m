Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:46043 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbZBLWpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2009 17:45:02 -0500
Received: by ti-out-0910.google.com with SMTP id d10so613394tib.23
        for <linux-media@vger.kernel.org>; Thu, 12 Feb 2009 14:45:00 -0800 (PST)
Message-ID: <4994A667.2000909@gmail.com>
Date: Fri, 13 Feb 2009 09:44:55 +1100
From: gilles <gilles.gigan@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Comments on V4L controls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
Sorry for double posting, but I originally sent this to the old mailing
list. Here it is:

I have a couple of comments / suggestions regarding the part on controls of
the V4L2 api:
Some controls, such as pan relative and tilt relative are write-only, and
reading their value makes little sense. Yet, there is no way of knowing
about this, but to try and read a value and be greeted with EINVAL or
similar. There is already a read-only flag (V4L2_CTRL_FLAG_READ_ONLY) in
struct v4l2_query. Does it make sense to add another one for write-only
controls ?
The extended controls Pan / Tilt  reset are defined in the API as boolean
controls. Shouldnt these be defined as buttons instead, as they dont really
hold a state (enabled/disabled) ?
Comments are welcome.
Cheers,
Gilles

