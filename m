Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.emlix.com ([193.175.82.87]:39218 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZC3Ngu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 09:36:50 -0400
Message-ID: <49D0CAEA.1070405@emlix.com>
Date: Mon, 30 Mar 2009 15:36:42 +0200
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Chris Zankel <chris@zankel.net>, linux-media@vger.kernel.org
Subject: Re: [patch 5/5] saa7121 driver for s6000 data port
References: <13003.62.70.2.252.1238080086.squirrel@webmail.xs4all.nl> <200903301203.02327.hverkuil@xs4all.nl> <49D0B71A.5080801@emlix.com> <200903301450.05240.hverkuil@xs4all.nl>
In-Reply-To: <200903301450.05240.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2009 02:50 PM, Hans Verkuil wrote:
> On Monday 30 March 2009 14:12:10 Daniel Glöckner wrote:
>> - valid CRC and line number in digital blanking?
> 
> Do you really need to control these?

Not on this board..

> It's a PAL/NTSC encoder, so the standard specified with s_std_output will
> map to the corresponding values that you need to put in. This is knowledge
> that the i2c driver implements.

There is a micron camera connected to the controller that can output any
resolution up to 1600x1200 and we don't have standard ids for all those HD
formats supported by encoders like the ADV7197. It would be really nice to
have an interface that covers all this while being symmetric for input and output.

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax -11, Bahnhofsallee 1b, 37081 Göttingen, Germany
Geschäftsführung: Dr. Uwe Kracke, Dr. Cord Seele, Ust-IdNr.: DE 205 198 055
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160

emlix - your embedded linux partner
