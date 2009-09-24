Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1812 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbZIXFly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 01:41:54 -0400
Received: from pao.localnet (72-254-98-227.client.stsn.net [72.254.98.227])
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id n8O5ft0x015287
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 24 Sep 2009 07:41:57 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: V4L-DVB Summit Day 1
Date: Wed, 23 Sep 2009 22:39:19 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909232239.20105.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

As most of you know I organized a v4l-dvb summit (well, really a v4l2 summit 
as there were no dvb topics to discuss) during the Linux Plumbers Conference 
in Portland. This summit will take all three days of this conference, and I 
intend to make a short report at the end of each day.

First of all I want to thank everyone who attended this first day of the 
summit: we had a great turn-out with seven core v4l-dvb developers, three TI 
engineers, two Nokia engineers, two engineers from Samsung and an Intel 
engineer. I know I've forgotten someone, I'll try to fix that tomorrow.

But it meant that the main SoC vendors with complex video hardware were well 
represented.

The summit started off with an overview of the proposed media controller and 
an overview of the features of several SoCs to give an idea of what sort of 
complexity has to be supported in the future. I'll try to get some of the 
presentations up on my site. Unfortunately, not all presentations can be made 
public. The main message that came across though is that these complex devices 
with big pipelines, scalers, composers, colorspace converters, etc. require a 
completely new way of working.

While we did discuss the concepts of the media controller, we did not go into 
much detail: that is scheduled for Thursday.

In the afternoon we discussed the proposed timings API. There was no 
opposition to this API. The idea I had to also use this for sensor setup 
turned out to be based on a misconception on how the S_FMT relates to sensors. 
ENUM_FRAMESIZES basically gives you the possible resolutions that the scaler 
hidden inside the bridge can scale the native sensor resolution. It does not 
enumerate the various native sensor resolutions, since there is only one. So 
S_FMT really sets up the scaler.

So we can proceed with the timings RFC and hopefully have this implemented for 
2.6.33.

Next was the event API proposal: this caused some more discussions, in 
particular since the original RFC had no provision for (un)subscribing to 
events. The idea is that we want to subscribe to events on a per-filehandle 
basis. The core framework can keep track of events and distribute them to 
filehandles that 'listen' to them. So this RFC will clearly need to go to at 
least one revision.

That was also a good point to stop for the day and head out to get free beer 
and food :-)

Scheduled for Thursday is a discussion of the proposed memory pool and 
continued media controller discussions.

Regards,

        Hans
