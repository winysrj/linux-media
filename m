Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:57078 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755845Ab0JRNxB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:53:01 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v14 0/1] V4L2: Documentation: hw_seek spacing, tuner/modulator
Date: Mon, 18 Oct 2010 16:52:36 +0300
Message-Id: <1287409957-25251-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi.

Thanks for the comments:

On Mon, 2010-10-18 at 15:17 +0200, ext Hans Verkuil wrote:
> Just a few very small comments:

OK...

>> +the linux-media mailing list: &v4l-ml;. </para>
> 
> Change to:
> 
> not yet exist, so if you are planning to write such a driver you
> should discuss this on the linux-media mailing list: &v4l-ml;.</para>

Changed...

> > -	    <entry>An incorrectable error occurred.</entry>
> > +	    <entry>An uncorrectable error occurred.</entry>
> 
> In addition to this change we should also specify that BLOCK_INVALID,
> BLOCK_ERROR and BLOCK_CORRECTED are for reading only, not for writing.

Added "read-only" comment to these bits.

Cheers,
Matti


Matti J. Aaltonen (1):
  Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.

 Documentation/DocBook/v4l/dev-rds.xml              |   68 +++++++++++++++-----
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 ++-
 2 files changed, 59 insertions(+), 19 deletions(-)

