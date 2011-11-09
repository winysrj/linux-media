Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KITCD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Nov 2011 14:02:03 -0500
Message-ID: <4EBACE27.8000907@redhat.com>
Date: Wed, 09 Nov 2011 17:01:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Michael Krufky <mkrufky@kernellabs.com>
Subject: DVBv5 frontend library
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

As I've commented with some at the KS, I started writing a new DVB library, based on DVBv5.
It is currently at very early stages. Help and suggestions are welcome.

It is at:
	http://git.linuxtv.org/mchehab/experimental-v4l-utils.git/shortlog/refs/heads/dvb-utils

It currently doesn't do much, but the hole idea is to offer a library that can easily
upgraded to support new standards, and based on DVBv5.

The new stuff is under utils/dvb dir.

For now, it has only a few files:

gen_dvb_structs.pl: Extracts DVBv5 API information from dvb/frontend.h.
Just as a commodity, for now, the DVB API spec were copied as dvb_frontend.h
inside the tree.

dvb-v5.h: a file, generated from dvb/frontend.h using the perl script.
It basically defines a name for each enum value inside the dvb/frontend.h header.

The frontend library is inside:
	dvb-fe.c  
	dvb-fe.h 

And the pertinent parameters needed by each delivery system is provided into
a separate header:
	dvb-v5-std.h  

There's a small test tool that currently just queries the DVB capabilities,
at:
	dvb-fe-tool.c  

The test tool currently does nothing but querying the device capabilities, identifying
the supported delivery systems.

I hope this could be helpful for the ones working with DVBv5. Patches, suggestions, etc
are welcome.

Regards,
Mauro
