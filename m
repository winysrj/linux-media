Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3053 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBDLG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 06:06:59 -0500
Message-ID: <52F0C908.6060302@xs4all.nl>
Date: Tue, 04 Feb 2014 12:03:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Martin Bugge <marbugge@cisco.com>,
	"prabhakar.csengg@gmail.com" <prabhakar.csengg@gmail.com>
Subject: RFC: how to set the colorspace for an output sub-device?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

We have the following situation: we use a ths8200 to send video out
over a VGA connector. It receives RGB video from a videoport DMA
engine. However, we want to be able to tell the ths8200 to convert
the RGB to YUV and send out YUV over the VGA connector instead of
RGB. Yeah, I know, it's odd, but it turns out that there are some
cases where that is needed (some cameras do that).

The question is, how do we tell the ths8200 to do that?

Currently in our repository we effectively implement it as another
output. So even though there is only one connector, the bridge driver
says that there are three, one RGB VGA and two YUV VGA using slightly
different YUV colorspaces. The bridge driver will call s_routing in
ths8200 and that sets up the colorspace conversion hardware.

There really is no way in the spec to explicitly define the colorspace
in a case like this. VIDIOC_S_FMT does has a colorspace field, but
that's for the video data in memory, and that remains RGB in this case.

In the subdev video ops you can also specify the colorspace of the
video going over a mediabus, but again that's RGB as well and we
don't have a way to specify this for the actual output.

I don't like the 'multiple outputs' idea. It's really a hack.

One option is to add a colorspace field to struct v4l2_bt_timings
(or to v4l2_dv_timings since it is not really specific to BT 656/1120).

If it is 0, then the default colorspace suitable for that connector
and format is used. If it is non-zero it can be used to specify which
colorspace the output should have (or, for receivers, which colorspace
the input has).

On the other hand, the colorspace doesn't really have anything to do
with the timings, so perhaps this isn't the best option.

Another alternative is to add RX and TX colorspace controls similar
to the RGB_RANGE controls that already exist today:
http://hverkuil.home.xs4all.nl/spec/media.html#dv-controls

E.g. V4L2_CID_TX_COLORSPACE

with options:

"Auto"
"SMPTE 170M"
"SMPTE 240M"
etc, etc. (same as colorspace defines)

One thing that is missing in the colorspaces are support for limited/full
range. During the Edinburgh summit we decided to add new colorspaces for
that. Adding this will make the TX/RX_RGB_RANGE controls obsolete since
those will be folded into the new COLORSPACE controls.

I think I like this approach better than the 'multiple outputs' or
the v4l2_dv_timings change.

Does anyone have other ideas or feedback?

Regards,

	Hans
