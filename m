Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab2JFOpS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 10:45:18 -0400
Date: Sat, 6 Oct 2012 11:45:09 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: How to add support for the em2765 webcam Speedlink VAD Laplace
 to the kernel ?
Message-ID: <20121006114509.25f07106@infradead.org>
In-Reply-To: <20121006085624.128f7f2c@redhat.com>
References: <5032225A.9080305@googlemail.com>
	<50323559.7040107@redhat.com>
	<50328E22.4090805@redhat.com>
	<50337293.8050808@googlemail.com>
	<50337FF4.2030200@redhat.com>
	<5033B177.8060609@googlemail.com>
	<5033C573.2000304@redhat.com>
	<50349017.4020204@googlemail.com>
	<503521B4.6050207@redhat.com>
	<503A7097.4050709@googlemail.com>
	<505F16AD.8010909@googlemail.com>
	<20121006085624.128f7f2c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 6 Oct 2012 08:56:24 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> > Unfortunately, lots of changes to the ov2640 driver would be necessary
> > use it. It starts with the init sequence and continues with a long
> > sequence of sensor register writes at capturing start.
> > My hope was, that the differences can be neglected, but unfortunately
> > this is not the case.
> > Given the amount of work, the fact that most of these registers are
> > undocumented and the high risk to break things for other users of the
> > driver, I think we should stay with the "custom" code for this webcam at
> > least for the moment.
> 
> Well, then do a new ov2640 i2c driver. We can later try to merge both, if
> we can get enough spec data.

Just to be clearer here: we should only fork ov2640 if we can't find a way
to re-use the existing driver. Forked drivers are always a maintenance
headache.

Cheers,
Mauro
