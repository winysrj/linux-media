Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:50318 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZBQWii (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 17:38:38 -0500
Received: by gxk22 with SMTP id 22so4730486gxk.13
        for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 14:38:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499B3A60.90306@linuxtv.org>
References: <20090217155335.GB6196@opus.istwok.net>
	 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
	 <499B1E19.80302@linuxtv.org> <20090217205629.GA9722@opus.istwok.net>
	 <412bdbff0902171305j26827e3fp2852f3774a788a67@mail.gmail.com>
	 <499B3A60.90306@linuxtv.org>
Date: Tue, 17 Feb 2009 17:38:37 -0500
Message-ID: <412bdbff0902171438u7c2ab531y62bb6c717647e917@mail.gmail.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: David Engel <david@istwok.net>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 17, 2009 at 5:29 PM, Steven Toth <stoth@linuxtv.org> wrote:
> The driver is probably buggy. Either its really reporting pre-viterbi errors
> OR it's reporting real post-viterbi errors - but in which case why aren't we
> also measuring uncorrected blocks?
>
> Regardless of Davids actual current problem, this sounds like a secondary
> unrelated issue.
>
> - Steve

Sorry, I didn't intend to suggest that the BER code isn't buggy - just
that I doubt it has any bearing on his actual problem since they occur
regardless of whether the other cards are running.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
