Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:8274 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab2IRKx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 06:53:28 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [RFCv1 PATCH 00/11] davinci: clean up input/output/subdev config
Date: Tue, 18 Sep 2012 12:53:02 +0200
Message-Id: <1347965593-16746-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

This patch series does some driver cleanup and reorganizes the config
structs that are used to set up subdevices.

The current driver associates an input or output with a subdev, but multiple
inputs may use the same subdev and some inputs may not use a subdev at all
(this is the case for our hardware).

Several other things were also configured in the wrong structure. For
example the vpif_interface struct is really part of the channel config
and has nothing to do with the subdev.

What is missing here is that the output doesn't have the same flexibility
as the input when it comes to configuration. It would be good if someone
can pick this up as a follow-up since it's unlikely I'll be working on
that.

What would also be nice is that by leaving the inputs or outputs for the
second channel empty (NULL) in the configuration you can disable the second
video node, e.g. trying to use it will always result in ENODEV or something.

This patch series will at least make things more flexible.

Regards,

	Hans

