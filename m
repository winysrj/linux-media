Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:49331 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbZBQVFz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 16:05:55 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1180791yxm.1
        for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 13:05:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090217205629.GA9722@opus.istwok.net>
References: <20090217155335.GB6196@opus.istwok.net>
	 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
	 <499B1E19.80302@linuxtv.org> <20090217205629.GA9722@opus.istwok.net>
Date: Tue, 17 Feb 2009 16:05:53 -0500
Message-ID: <412bdbff0902171305j26827e3fp2852f3774a788a67@mail.gmail.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: David Engel <david@istwok.net>
Cc: Steven Toth <stoth@linuxtv.org>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 17, 2009 at 3:56 PM, David Engel <david@istwok.net> wrote:
> I have anohter system, with only an ATSC 115 and a video card.  It has
> nearly identical numbers from femon as the system with the PVRs.

Didn't the PVR-250/350 have some sort of PCI DMA issues?  (I thought I
remember reading that  couple of years ago but I may be crazy).  If
so, then that wouldn't show up with femon, as the demod and tuner
would be capturing fine, but then the packets would never make it back
to the host.

<Idle speculation mode off>

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
