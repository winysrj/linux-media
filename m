Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab1C1Vk1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Mar 2011 17:40:27 -0400
Message-ID: <4D910042.4030100@redhat.com>
Date: Mon, 28 Mar 2011 18:40:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
References: <777PcLohh6368S03.1299940473@web03.cms.usa.net>	<4D7B8A07.70602@linuxtv.org> <19855.55774.192407.326483@morden.metzler>
In-Reply-To: <19855.55774.192407.326483@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 27-03-2011 21:44, Ralph Metzler escreveu:
> Hi,
> 
> since I just saw cxd2099 appear in staging in the latest git kernel, a
> simple question which has been pointed out to me before:
> 
> Why is cxd2099.c in staging regarding the device name question?
> It has nothing to do with the naming.

It is not just because of naming. A NACK was given to it, as is, at:

http://www.spinics.net/lists/linux-media/msg28004.html

A previous discussion about this subject were started at:
	http://www.mail-archive.com/linux-media@vger.kernel.org/msg22196.html

The point is that an interface meant to be used by satellite were
used as a ci interface, due to the lack of handling independent CA devices.

As there were no final decision about a proper way to address it, Oliver
decided to keep it as-is, and I decided to move it to staging while we
don't properly address the question, extending the DVB API in order to support
independent CA devs.

Having the driver at staging allow us to rework at the API and change the
driver when API changes are done, without needing to pass through kernel 
process of deprecating old API stuff.

Cheers,
Mauro
