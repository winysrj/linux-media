Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:14797 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755230Ab0GCNUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 09:20:35 -0400
Subject: Re: MCEUSB memory leak and how to tell if ir_register_input()
 failure  registered input_dev?
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTinda8JSa3XRZSSbEuj9JKVkLnRNwnW4YGBtDfWj@mail.gmail.com>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
	 <20100607193238.21236.72227.stgit@localhost.localdomain>
	 <4C273FFE.4090300@redhat.com>
	 <AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
	 <1277680645.3347.7.camel@localhost>
	 <AANLkTinda8JSa3XRZSSbEuj9JKVkLnRNwnW4YGBtDfWj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Jul 2010 09:20:51 -0400
Message-ID: <1278163251.2304.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-06-27 at 23:34 -0400, Jarod Wilson wrote:
> On Sun, Jun 27, 2010 at 7:17 PM, Andy Walls <awalls@md.metrocast.net> wrote:

> > Mauro and Jarrod,
> >
> > When ir_register_input() fails, it doesn't indicate whether or not it
> > was able to register the input_dev or not.  To me it looks like it can
> > return with failure with the input_dev either way depending on the case.
> > This makes proper cleanup of the input_dev in my cx23885_input_init()
> > function difficult in the failure case, since the input subsystem has
> > two different deallocators depending on if the device had been
> > registered or not.
> 
> Hm. I've done a double-take a few times now, but if
> input_register_device is successful, and something later in
> __ir_input_register fails, input_unregister_device *does* get called
> within __ir_input_register, so all you should have to do is call
> input_free_device in your init function's error path, no?


I couldn't quite tell (with the constant stream of intteruptions I get
at times).  That's why I asked. :)

I'll double check today once I'm done with getting the CX23888 IR Tx
working.

Regards,
Andy

