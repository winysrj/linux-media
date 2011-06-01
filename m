Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1FAMzk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 08:55:40 -0400
Message-ID: <4DE636C5.7040604@redhat.com>
Date: Wed, 01 Jun 2011 09:55:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [GIT PATCHES FOR 2.6.41] Add bitmask controls
References: <201105231315.29328.hverkuil@xs4all.nl>
In-Reply-To: <201105231315.29328.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Em 23-05-2011 08:15, Hans Verkuil escreveu:
> Hi Mauro,
> 
> These patches for 2.6.41 add support for bitmask controls, needed for the
> upcoming Flash API and HDMI API.

DocBook changes need do a s/2.6.41/3.1/. 

That's said, I'm not sure if it is a good idea to add bitmask type, instead of
just using a set of boolean controls. One of the issues with bitmasks is the
endness type: LE, BE or machine endianness. The specs don't mention how this
is supposed to work.

Also, I'd like to see a patch like that submitting with a driver or feature
that needs it. Before you ask: no, vivi doesn't count ;)

> Sakari, can you give your ack as well?
> 
> The patch is the same as the original one posted April 4, except for a small
> change in the control logging based on feedback from Laurent and the new
> DocBook documentation.

Cheers,
Mauro
