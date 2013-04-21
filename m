Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab3DUNHg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 09:07:36 -0400
Message-ID: <5173E48C.1060903@redhat.com>
Date: Sun, 21 Apr 2013 10:07:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC v2 0/3] Add SDR at V4L2 API
References: <366469499-31640-1-git-send-email-mchehab@redhat.com> <201304211134.09073.hverkuil@xs4all.nl> <5173BAEF.3000805@redhat.com> <201304211234.45282.hverkuil@xs4all.nl> <5173C910.3000803@redhat.com> <5173D576.7090404@iki.fi>
In-Reply-To: <5173D576.7090404@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-04-2013 09:03, Antti Palosaari escreveu:
> You just jumped over all my previous hard work and introduced implementation, as I tried still to study and finalize all requirements....

As it is posted on the topics, this is RFC. I'm sure changes will
be needed there before having it on some state that it can be merged.

>
> http://palosaari.fi/linux/kernel_sdr_api_requirement_specification.txt

Well, we discussed there already:
	http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/63123

And I proposed several a few implementation details there. I'm just
going deeper and writing RFC patches to start test/implement it.

> I don't like that. I want just study all requirements and implement
> those as a once and correctly.

Ok, there are topics there yet to study, but in order to to that,
a real implementation is needed. Only implementing it is possible
to cover all that it is needed.

> That one does not meet very many of those listed requirements.

True. It doesn't cover anything that IMO it should be covered by V4L2
controls.

My focus right now is to implement support for:
	- set/get frequency;
	- get IF;
	- set/get standard envelope/bandwidth;
	- set/get sample rate (the real code will only show up
	  when start implementing a SDR driver - I'm yet far
	  behind this point);
	- get tuner frequency range.

Adding new controls are the easy task, as it doesn't require
core changes (well, except for a table there with the control
names).

However, adding core support for SDR is harder, as it requires
to work on several layers at the V4L2 core.

I'm working today on more patches for it, at tuner-core.
Lots of changes are required there, in order to allow
supporting the existing tuner.

My current plan is to test SDR with cx88, so, I need tuner-core
to work fine with it. I've coded only ~50% of what's needed,
and that represents:

  15 files changed, 379 insertions(+), 94 deletions(-)

Regards,
Mauro
