Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:37545 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114Ab0ARWQ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 17:16:58 -0500
Subject: Re: Do any drivers access the cx25840 module in an atomic context?
From: Andy Walls <awalls@radix.net>
To: Mike Isely <isely@isely.net>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stoth@kernellabs.com, Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <alpine.DEB.1.10.1001181407470.13307@cnc.isely.net>
References: <1263791968.5220.87.camel@palomino.walls.org>
	 <alpine.DEB.1.10.1001181407470.13307@cnc.isely.net>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 17:16:05 -0500
Message-Id: <1263852965.7750.31.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-01-18 at 14:18 -0600, Mike Isely wrote:
> On Mon, 18 Jan 2010, Andy Walls wrote:> 
> > Any definitive confirmation anyone can give on any of these drivers
> > would be helpful and would save me some time.


Mike,

Great!  Thank you for the answers.

If you would indulge one more (compound) question:

Looking at the I2C master implementation in pvrusb2, it looks like it
would be OK for me to combine the i2c_master_write() and
i2c_master_read() in cx25840_read() into a single 2 "msg" i2c_transfer()
without the pvrusb2 driver having a problem.

a. Is that correct?
b. Is there a limit on the combined payload, such that a the
cx25840_read4() would not work as a combined i2c_transfer() ?

Regards,
Andy


