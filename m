Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:60137 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0DQNBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 09:01:12 -0400
Message-ID: <4BC9B10C.9080508@pobox.com>
Date: Sat, 17 Apr 2010 09:01:00 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
Subject: Re: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com> <4B8CA8DD.5030605@teksavvy.com>
 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
 <1270961760.5365.14.camel@palomino.walls.org>
 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
 <1271209520.4102.18.camel@palomino.walls.org> <4BC54569.7020301@pobox.com>
 <4BC64119.5070200@pobox.com> <1271306803.7643.67.camel@palomino.walls.org>
 <4BC6A135.4070400@pobox.com>  <4BC71F86.4020509@pobox.com>
 <1271479406.3120.9.camel@palomino.walls.org> <4BC9A507.3080807@pobox.com>
In-Reply-To: <4BC9A507.3080807@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/04/10 08:09 AM, Mark Lord wrote:
..
> Mmm.. something is not right -- the audio is failing constantly with that change.
> Perhaps if I could dump out the registers, we might see what is wrong.
..

When the microcontroller is reset, does it put all settings back to defaults?
I wonder if this causes it to select a different audio input, as part of the reset?

If so, then we'll need to reselect the tuner-audio afterward.
Anything else?


??
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
