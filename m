Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4855 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbZC3Nm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 09:42:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>
Subject: Re: [patch 5/5] saa7121 driver for s6000 data port
Date: Mon, 30 Mar 2009 15:41:52 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org
References: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl> <200903301450.05240.hverkuil@xs4all.nl> <49D0CAEA.1070405@emlix.com>
In-Reply-To: <49D0CAEA.1070405@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903301541.52497.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 30 March 2009 15:36:42 Daniel Glöckner wrote:
> On 03/30/2009 02:50 PM, Hans Verkuil wrote:
> > On Monday 30 March 2009 14:12:10 Daniel Glöckner wrote:
> >> - valid CRC and line number in digital blanking?
> > 
> > Do you really need to control these?
> 
> Not on this board..
> 
> > It's a PAL/NTSC encoder, so the standard specified with s_std_output will
> > map to the corresponding values that you need to put in. This is knowledge
> > that the i2c driver implements.
> 
> There is a micron camera connected to the controller that can output any
> resolution up to 1600x1200 and we don't have standard ids for all those HD
> formats supported by encoders like the ADV7197. It would be really nice to
> have an interface that covers all this while being symmetric for input and output.

This is a known issue. I expect to see some proposals for this in the near
future since Texas Instruments need this as well for their davinci architecture.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
