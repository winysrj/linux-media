Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbZKZU7V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 15:59:21 -0500
Message-ID: <4B0EEC21.9010001@redhat.com>
Date: Thu, 26 Nov 2009 18:59:13 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDcc3mfojFB@christoph>
In-Reply-To: <BDcc3mfojFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Bartelmus wrote:
> Hi Mauro,
> 
> on 26 Nov 09 at 10:36, Mauro Carvalho Chehab wrote:
> [...]
>> lircd supports input layer interface. Yet, patch 3/3 exports both devices
>> that support only pulse/space raw mode and devices that generate scan
>> codes via the raw mode interface. It does it by generating artificial
>> pulse codes.
> 
> Nonsense! There's no generation of artificial pulse codes in the drivers.
> The LIRC interface includes ways to pass decoded IR codes of arbitrary  
> length to userspace.

I might have got wrong then a comment in the middle of the 
imon_incoming_packet() of the SoundGraph iMON IR patch:

+	/*
+	 * Translate received data to pulse and space lengths.
+	 * Received data is active low, i.e. pulses are 0 and
+	 * spaces are 1.
+	 *
+	 * My original algorithm was essentially similar to
+	 * Changwoo Ryu's with the exception that he switched
+	 * the incoming bits to active high and also fed an
+	 * initial space to LIRC at the start of a new sequence
+	 * if the previous bit was a pulse.
+	 *
+	 * I've decided to adopt his algorithm.
+	 */

Cheers,
Mauro.
