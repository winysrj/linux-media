Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0BCJta (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 04:49:30 -0500
Message-ID: <4B6946A3.9080803@redhat.com>
Date: Wed, 03 Feb 2010 07:49:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Julian Scheel <julian@jusst.de>
CC: linux-media@vger.kernel.org
Subject: Re: New DVB-Statistics API - please vote
References: <4B1E1974.6000207@jusst.de> <4B1E532C.9040903@redhat.com>
In-Reply-To: <4B1E532C.9040903@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

>> after the last thread which asked about signal statistics details
>> degenerated into a discussion about the technical possibilites for
>> implementing an entirely new API, which lead to nothing so far, I wanted
>> to open a new thread to bring this forward. Maybe some more people can
>> give their votes for the different options

Only me and Manu manifested with opinions on this thread. Not sure why
nobody else gave their comments. Maybe all interested people just decided 
to take a long vacation and are not listening to their emails ;)

Seriously, from what I understand, this is an API improvement and we need
to take a decision on it. So, your opinions are important.

---

Let me draw a summary of this subject, trying to be impartial.

The original proposal were made by Manu. My proposal is derived from Manu's
original one, both will equally provide the same features. 

The main difference is that Manu's proposal use a struct to get the 
statistics while my proposal uses DVBS2API.

With both API proposals, all values are get at the same time by the driver.
the DVBS2API adds a small delay to fill the fields, but the extra delay is
insignificant, when compared with the I/O delays needed to retrieve the 
values from the hardware.

Due to the usage of DVBS2API, it is possible to retrieve a subset of statistics.
When obtaining a subset, the DVBS2API latency is considerable faster, as less
data needed to be transfered from the hardware.

The DVBS2API also offers the possibility of expanding the statistics group, since
it is not rigid as an struct.

One criteria that should be reminded is that, according with Linux Kernel rules,
any userspace API is stable. This means that applications compiled against an
older API version should keep running with the latest kernel. So, whatever decided,
the statistics API should always maintain backward compatibility.

---

During the end of the year, I did some work with an ISDB-T driver for Siano, and
I realized that the usage of the proposed struct won't fit well for ISDB-T. The
reason is that, on ISDB-T, the transmission uses up to 3 hierarchical layers.
Each layer may have different OFDM parameters, so the devices (at least, this is the 
case for Siano) has a group of statistics per layer.

I'm afraid that newer standards may also bring different ways to present statistics, and
the current proposal won't fit well.

So, in my opinion, if it is chosen any struct-based approach, we'll have a bad time to
maintain it, as it won't fit into all cases, and we'll need to add some tricks to extend
the struct.

So, my vote is for the DVBS2API approach, where a new group of statistics can easily be added,
on an elegant way, without needing of re-discussing the better API or to find a way to extend
the size of an struct without breaking backward compatibility.

Cheers,
Mauro
