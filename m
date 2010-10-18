Return-path: <mchehab@pedra>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:16549 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0JRM6F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 08:58:05 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v13 0/1] V4L2: Documentation: hw_seek spacing, tuner/modulator
Date: Mon, 18 Oct 2010 15:57:36 +0300
Message-Id: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello.

Thank you for the comments. Here are my comments to Hans's comments:

On Thu, 2010-10-14 at 08:41 +0200, ext Hans Verkuil wrote:
> 
> This can be improved a bit:

Yes...

> I think that for now we should only mention BLOCK_IO here since we do
> not know yet what controls would be used if the receiver would
> understand that. There are no devices yet that support that
> mode. Perhaps we should mention instead that if someone has hardware
> that can decode rds automagically that they should contact the
> mailing list.
> Can you also add a link to the "Reading RDS data"
> section when describing the BLOCK_IO capability?

I more or less did the above. 

> The RDS interface section should be extended with a "Writing RDS data"
> section, and a link should be added to that new section when
> describing the BLOCK_IO capability here.
> 
> Just read carefully through the "RDS interface" section and make sure
> it is no longer exclusively referring to the receiver API.
> 
> You should alse add a link to the "FM Transmitter Control Reference"
> section when describing the CONTROLS capability.


I added "Writing RDS data" section etc...

B.R.
Matti

Matti J. Aaltonen (1):
  Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.

 Documentation/DocBook/v4l/dev-rds.xml              |   60 ++++++++++++++------
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +++-
 2 files changed, 51 insertions(+), 19 deletions(-)

