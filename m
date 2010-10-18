Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab0JRNlN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:41:13 -0400
Message-ID: <4CBC4E73.70601@redhat.com>
Date: Mon, 18 Oct 2010 11:41:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v13 1/1] Documentation: v4l: Add hw_seek spacing and
 two TUNER_RDS_CAP flags.
References: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>    <1287406657-18859-2-git-send-email-matti.j.aaltonen@nokia.com> <9c6327556dad0b210e353c11126e2ceb.squirrel@webmail.xs4all.nl>
In-Reply-To: <9c6327556dad0b210e353c11126e2ceb.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-10-2010 11:17, Hans Verkuil escreveu:
> Just a few very small comments:

>> +For future use the
>> +flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> has also been
>> +defined. However, a driver for a radio tuner with this capability does
>> +not yet exist, so if you are planning to write such a driver the best
>> +way to start would probably be by opening a discussion about it on
>> +the linux-media mailing list: &v4l-ml;. </para>
> 
> Change to:
> 
> not yet exist, so if you are planning to write such a driver you
> should discuss this on the linux-media mailing list: &v4l-ml;.</para>

No, please. Don't add any API capabilities at the DocBook without having a driver
using it. At the time a driver start needing it, we can just add the API bits
and doing the needed discussions as you've proposed. This is already implicit.

Cheers,
Mauro
