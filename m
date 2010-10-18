Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2539 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0JRN5a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 09:57:30 -0400
Message-ID: <ec5341251875e33faaea9cc94c160978.squirrel@webmail.xs4all.nl>
In-Reply-To: <4CBC4E73.70601@redhat.com>
References: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>
    <1287406657-18859-2-git-send-email-matti.j.aaltonen@nokia.com>
    <9c6327556dad0b210e353c11126e2ceb.squirrel@webmail.xs4all.nl>
    <4CBC4E73.70601@redhat.com>
Date: Mon, 18 Oct 2010 15:57:11 +0200
Subject: Re: [PATCH v13 1/1] Documentation: v4l: Add hw_seek spacing and  
 two TUNER_RDS_CAP flags.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Em 18-10-2010 11:17, Hans Verkuil escreveu:
>> Just a few very small comments:
>
>>> +For future use the
>>> +flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> has also been
>>> +defined. However, a driver for a radio tuner with this capability does
>>> +not yet exist, so if you are planning to write such a driver the best
>>> +way to start would probably be by opening a discussion about it on
>>> +the linux-media mailing list: &v4l-ml;. </para>
>>
>> Change to:
>>
>> not yet exist, so if you are planning to write such a driver you
>> should discuss this on the linux-media mailing list: &v4l-ml;.</para>
>
> No, please. Don't add any API capabilities at the DocBook without having a
> driver
> using it. At the time a driver start needing it, we can just add the API
> bits
> and doing the needed discussions as you've proposed. This is already
> implicit.

These caps are shared between tuner and modulator. And for the modulator
both caps *are* used in Matti's driver. But while RDS_CONTROLS is
available for modulators, it is not yet applicable to tuners and for that
we need to make this note in the spec.

So this is an exception to the rule, I'm afraid.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

