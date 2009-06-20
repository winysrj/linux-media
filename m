Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2306 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZFTNFh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 09:05:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: FM modulator and RDS encoder V4L2 API additions
Date: Sat, 20 Jun 2009 15:05:24 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	eduardo.valentin@nokia.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906201505.24721.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Besides the new RDS controls implemented by Eduardo we also need a few 
additions to the V4L2 API.

First of all we need two new capabilities for struct v4l2_capability:

#define V4L2_CAP_RDS_OUTPUT     0x0000800 /* Is an RDS encoder */
#define V4L2_CAP_MODULATOR 	0x0008000 /* has a modulator */

The current V4L2 spec says in section 1.6.2 that you should set 
V4L2_CAP_TUNER when you have a modulator. I see absolutely no reason why we 
shouldn't add a proper CAP_MODULATOR instead. Almost all caps already come 
in an input and output variant, so it also makes sense to have a tuner and 
a separate modulator capability. Since Eduardo's FM transmitter is the 
first driver with a modulator that will go into the tree we do not have to 
worry about backwards compatibility, so I think we should fix this weird 
rule.

For the same reason we should add an RDS_OUTPUT capability since not all FM 
transmitters might have a RDS encoder. Again, this is also consistent with 
the V4L2_CAP_RDS_CAPTURE capability that we already have.

The RDS decoder API adds a new v4l2_tuner RDS capability and RDS subchannel 
flag. These are reused in v4l2_modulator. If the RDS capability is set, 
then the modulator can encode RDS. If the V4L2_TUNER_SUB_RDS channel is 
specified in txsubchans, then the transmitter will turn on the RDS encoder, 
otherwise it is turned off. This is consistent with the way txsubchans is 
used for the audio modulation.

Eduardo, this will replace the RDS_TX_ENABLED control, so if this goes in 
then that control has to be removed.

I've made a first implementation of these changes in this tree: 
http://linuxtv.org/hg/~hverkuil/v4l-dvb-rds-enc

This tree also contains the RDS decoder changes from my v4l-dvb-rds tree 
since it needs to build on those.

Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
