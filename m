Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44294 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab0DCAq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 20:46:57 -0400
Subject: Re: [RFC] Serialization flag example
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
In-Reply-To: <4BB65E67.9050605@redhat.com>
References: <201004011937.39331.hverkuil@xs4all.nl>
	 <4BB4E4CC.3020100@redhat.com>
	 <y2v1a297b361004021043wa43821d2hfb5b573b110dd5e0@mail.gmail.com>
	 <x2v829197381004021053nf77e2d42q4f1614eced7f999d@mail.gmail.com>
	 <4BB65E67.9050605@redhat.com>
Content-Type: text/plain
Date: Fri, 02 Apr 2010 20:47:05 -0400
Message-Id: <1270255625.3027.82.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-04-02 at 18:15 -0300, Mauro Carvalho Chehab wrote:
> Devin Heitmueller wrote:

> In the case of a V4L x DVB type of lock, this is not to protect some memory, but,
> instead, to limit the usage of a hardware that is not capable of simultaneously
> provide V4L and DVB streams. This is a common case on almost all devices, but, as
> Hermann pointed, there are a few devices that are capable of doing both analog
> and digital streams at the same time, but saa7134 driver currently doesn't support.

I know a driver that does:

cx18 can handle simultaneous streaming of DTV and analog.

Some cards have both an analog and digital tuner, so both DTV and analog
can come from an RF source simultaneously.  (No locking needed really.)

Some cards only have one tuner, which means simultaneous streaming is
limited to DTV from RF and analog from baseband inputs.  Streaming
analog from an RF source on these cards precludes streaming of DTV.  (An
odd locking ruleset when you consider MPEG, YUV, PCM, and VBI from the
bridge chip can independently be streamed from the selected analog
source to 4 different device nodes.)

Regards,
Andy


