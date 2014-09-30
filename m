Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbaI3OEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:04:54 -0400
Message-ID: <542AB87C.1070306@redhat.com>
Date: Tue, 30 Sep 2014 16:04:44 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org
Subject: Re: Regression: in v4l2 converter does not set the buffer.length
 anymore
References: <5429CDD6.9050809@collabora.com>
In-Reply-To: <5429CDD6.9050809@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/29/2014 11:23 PM, Nicolas Dufresne wrote:
> This was initially reported to GStreamer project:
> https://bugzilla.gnome.org/show_bug.cgi?id=737521
> 
> We track this down to be a regression introduced in v4l2-utils from version 1.4.0. In recent GStreamer we make sure the buffer.length field (retreived with QUERYBUF) is bigger or equal to the expected sizeimage (as obtained in S_FMT). This is to fail cleanly and avoid buffer overflow if a driver (or libv4l2) endup doing a short allocation. Since 1.4.0, this field is always 0 if an emulated format is selected.
> 
> Reverting patch 10213c brings back normal behaviour:
> http://git.linuxtv.org/cgit.cgi/v4l-utils.git/commit/?id=10213c975afdfcc90aa7de39e66c40cd7e8a57f7
> 
> This currently makes use of any emulated format impossible in GStreamer. v4l2-utils 1.4.0 is being shipped at least in debian/unstable at the moment.

Oops, thanks for the bug report.

I've created a 3 patch patch-set fixing this, which I'll send right after
this mail. The actual fix is in the 2nd patch, the first patch and third
patches fix 2 unrelated bugs which I noticed while working on this.

Regards,

Hans
