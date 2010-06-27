Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:52777 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab0F0XRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 19:17:13 -0400
Subject: MCEUSB memory leak and how to tell if ir_register_input() failure
 registered input_dev?
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
References: <20100607192830.21236.69701.stgit@localhost.localdomain>
	 <20100607193238.21236.72227.stgit@localhost.localdomain>
	 <4C273FFE.4090300@redhat.com>
	 <AANLkTimDJAyvowo_1bLhKPhlDWzzMeF87or4MriJ_UT8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Jun 2010 19:17:25 -0400
Message-ID: <1277680645.3347.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Jarrod,

Looking at the patches branch from your WIP git tree:

Is mceusb_init_input_dev() supposed to allocate a struct ir_input_dev?
It looks like ir_register_input() handles that, and it is trashing your
pointer (memory leak).

Mauro and Jarrod,

When ir_register_input() fails, it doesn't indicate whether or not it
was able to register the input_dev or not.  To me it looks like it can
return with failure with the input_dev either way depending on the case.
This makes proper cleanup of the input_dev in my cx23885_input_init()
function difficult in the failure case, since the input subsystem has
two different deallocators depending on if the device had been
registered or not.

Regards,
Andy


