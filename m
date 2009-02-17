Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:36599 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbZBQWaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 17:30:07 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF800CJVEHSM510@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 17 Feb 2009 17:29:54 -0500 (EST)
Date: Tue, 17 Feb 2009 17:29:52 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: PVR x50 corrupts ATSC 115 streams
In-reply-to: <412bdbff0902171305j26827e3fp2852f3774a788a67@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: David Engel <david@istwok.net>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>
Message-id: <499B3A60.90306@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090217155335.GB6196@opus.istwok.net>
 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
 <499B1E19.80302@linuxtv.org> <20090217205629.GA9722@opus.istwok.net>
 <412bdbff0902171305j26827e3fp2852f3774a788a67@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Feb 17, 2009 at 3:56 PM, David Engel <david@istwok.net> wrote:
>> I have anohter system, with only an ATSC 115 and a video card.  It has
>> nearly identical numbers from femon as the system with the PVRs.
> 
> Didn't the PVR-250/350 have some sort of PCI DMA issues?  (I thought I
> remember reading that  couple of years ago but I may be crazy).  If
> so, then that wouldn't show up with femon, as the demod and tuner
> would be capturing fine, but then the packets would never make it back
> to the host.
> 
> <Idle speculation mode off>

The driver is probably buggy. Either its really reporting pre-viterbi errors OR 
it's reporting real post-viterbi errors - but in which case why aren't we also 
measuring uncorrected blocks?

Regardless of Davids actual current problem, this sounds like a secondary 
unrelated issue.

- Steve
