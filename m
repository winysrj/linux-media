Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48209 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088Ab0DQEnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 00:43:53 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC71F86.4020509@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
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
Content-Type: text/plain
Date: Sat, 17 Apr 2010 00:43:26 -0400
Message-Id: <1271479406.3120.9.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2010-04-15 at 10:15 -0400, Mark Lord wrote:

> And.. one of the "fallback" recordings still had muted audio.
> Even though my script which checks for that reported "audio ok".
> 
> Enough for now.. I'll hack some more on the weekend.

I had to disassemble and study some of the microcontorller firmware, and
then reread some documents, to figure out how all the audio detection
"resets" must work.

I've just pushed some microcontroller reset related changes to the
cx18-audio2 repo.  Please test and see if things are better or worse.  

The analog stations I had last weekend I can't seem to pick up anymore.

Regards,
Andy

