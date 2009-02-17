Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:57514 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZBQQF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 11:05:59 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF7005VGWPHI2Z0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 17 Feb 2009 11:05:52 -0500 (EST)
Date: Tue, 17 Feb 2009 11:05:40 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: PVR x50 corrupts ATSC 115 streams
In-reply-to: <20090217155335.GB6196@opus.istwok.net>
To: David Engel <david@istwok.net>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>
Message-id: <499AE054.6020608@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090217155335.GB6196@opus.istwok.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Does anyone know what might be going on?  These very same tuner cards
> worked fine in the old system (Intel P4 3.0GHz CPU and Abit IC7
> motherboard) for close to two years.

Determine whether this is an RF issue, or a DMA corruption issue:

1. Check the RF SNR of the digital cards using femon, anything odd going on when 
the PVR250 is running? Does it fall out of lock or SNR dip dangerously low, 
bursts of BER's?

2. Move the two cards as far apart as possible in the slots in the system and 
repeat the test above, any better?

What happens?

- Steve
