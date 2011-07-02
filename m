Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab1GBAzN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 20:55:13 -0400
Message-ID: <4E0E6C6E.7050408@redhat.com>
Date: Fri, 01 Jul 2011 21:55:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Some comments on the new autocluster patches
References: <4E0DE283.2030107@redhat.com>
In-Reply-To: <4E0DE283.2030107@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 01-07-2011 12:06, Hans de Goede escreveu:
> Hi Hans (et all),
> 
> I've been working on doing a much needed cleanup to the pwc driver,
> converting it to videobuf2 and using the new ctrl framework.
> 
> I hope to be able to send a pull request for this, this weekend.
> 
> I saw your pull request and I'm looking forward to be able to
> play with ctrl events. I do have some comments on your autofoo
> cluster patches and related changes though.
>

Hi Hans & Hans,

I've applied Hans V. patches at the tree, to allow them to be better
tested. I'm not 100% comfortable with the patches, and, from my understanding
the poll() changes are needed, in order to fix vivi behavior and add the
event patches for ivtv. I didn't have much time to test the patches (is qv4l2
already ready to test them?)

Due to that, it is probably safer to hold those patches to be merged upstream 
at 3.2, after playing with them for a while at the development tree and at -next.

So, feel free to suggest changes without being stick to the current API, as, while
they're not merging upstream, we can change/fix some things that aren't behaving
well.

Regards,
Mauro

