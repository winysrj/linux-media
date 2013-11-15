Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3KOLe1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 06:34:27 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20271.1384472102@warthog.procyon.org.uk>
References: <20271.1384472102@warthog.procyon.org.uk>
To: Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: dhowells@redhat.com, linux-media@vger.kernel.org,
	Jarkko Korpi <jarkko_korpi@hotmail.com>
Subject: Re: I2C transfer logs for Antti's DS3103 driver and DVBSky's DS3103 driver
Date: Fri, 15 Nov 2013 11:33:52 +0000
Message-ID: <28089.1384515232@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I think I've isolated the significant part of the demod register setup.
Discarding the reads and sorting them in address order, I see

ANTTI			DVBSKY			DIFFER?
=======================	=======================	=======
demod_write(22, [ac])	demod_write(22, [ac])	no
demod_write(24, [5c])	demod_write(24, [5c])	no
			demod_write(25, [8a])	YES
demod_write(29, [80])	demod_write(29, [80])	no
demod_write(30, [08])	demod_write(30, [08])	no
demod_write(33, [00])				YES
demod_write(4d, [91])	demod_write(4d, [91])	no
			demod_write(56, [00])	YES
demod_write(61, [5549])	demod_write(61, [55])	no
	"	"	demod_write(62, [49])	no
			demod_write(76, [38])	YES
demod_write(c3, [08])	demod_write(c3, [08])	no
demod_write(c4, [08])	demod_write(c4, [08])	no
demod_write(c7, [00])	demod_write(c7, [00])	no
demod_write(c8, [06])	demod_write(c8, [06])	no
demod_write(ea, [ff])	demod_write(ea, [ff])	no
demod_write(fd, [46])	demod_write(fd, [06])	YES
demod_write(fe, [6f])	demod_write(fe, [6f])	no

David
