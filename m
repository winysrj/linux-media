Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:60460 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980AbZC3J4e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 05:56:34 -0400
Message-ID: <49D09749.507@emlix.com>
Date: Mon, 30 Mar 2009 11:56:25 +0200
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org
Subject: Re: [patch 5/5] saa7121 driver for s6000 data port
References: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl>
In-Reply-To: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2009 04:08 PM, Hans Verkuil wrote:
> I've been working on a new framework for devices like this and almost all
> i2c v4l drivers are now converted to v4l2_subdev in our v4l-dvb tree. It
> will also be merged in 2.6.30. Please take a look at v4l2-framework.txt in
> the v4l-dvb repository for more information.
> 
> I'm sure you will have questions later, please don't hesitate to ask! It's
> a recent development but very much needed. Otherwise we will end up with a
> lot of duplicate i2c drivers, each tied to their own platform or
> framework. That's clearly something we do not want.

Hi Hans,

the problem I see with the v4l2-framework in this case is that in its current
state it does not allow to exchange information regarding the bus parameters
between the sub device and the controller.

It seems the soc-camera framework is a better choice here, but to make it work
with the saa7121 one would first have to implement support for video output.

What do you recommend?


  Daniel

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
