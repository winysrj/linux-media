Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730Ab0J2NqF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Oct 2010 09:46:05 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o9TDk4Vk022230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 29 Oct 2010 09:46:05 -0400
Message-ID: <4CCAD01A.3090106@redhat.com>
Date: Fri, 29 Oct 2010 11:46:02 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Apple remote support
References: <20101029031131.GE17238@redhat.com> <20101029031530.GH17238@redhat.com>
In-Reply-To: <20101029031530.GH17238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-10-2010 01:15, Jarod Wilson escreveu:
> On Thu, Oct 28, 2010 at 11:11:31PM -0400, Jarod Wilson wrote:
>> I've got one of those tiny little 6-button Apple remotes here, now it can
>> be decoded in-kernel (tested w/an mceusb transceiver).
> 
> Oh yeah, RFC, because I'm not sure if we should have a more generic "skip
> the checksum check" support -- I seem to recall discussion about it in the
> not so recent past. And a decoder hack for one specific remote is just
> kinda ugly...

Yeah, I have the same doubt. One possibility would be to simply report a 32 bits
code, if the check fails. I don't doubt that we'll find other remotes with
a "NEC relaxed" protocol, with no checksum at all.

Cheers,
Mauro.

