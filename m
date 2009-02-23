Return-path: <linux-media-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:13190 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbZBWWDb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 17:03:31 -0500
Received: by yw-out-2324.google.com with SMTP id 5so898774ywh.1
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 14:03:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49A31AE5.5030801@linuxtv.org>
References: <499AE054.6020608@linuxtv.org>
	 <20090218051945.GA12934@opus.istwok.net>
	 <499C218D.7050406@linuxtv.org>
	 <20090218153422.GC15359@opus.istwok.net>
	 <20090219162820.GA23759@opus.istwok.net> <49A1A8E4.8030307@rogers.com>
	 <20090223183946.GA13608@opus.istwok.net>
	 <49A2F3D0.9080508@linuxtv.org>
	 <20090223201054.GA14056@opus.istwok.net>
	 <49A31AE5.5030801@linuxtv.org>
Date: Mon, 23 Feb 2009 17:03:28 -0500
Message-ID: <412bdbff0902231403o3280709aq323f94a0a6acc5d0@mail.gmail.com>
Subject: Re: PVR x50 corrupts ATSC 115 streams
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Steven Toth <stoth@linuxtv.org>
Cc: linux-media@vger.kernel.org, V4L <video4linux-list@redhat.com>,
	David Engel <david@istwok.net>, CityK <cityk@rogers.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 23, 2009 at 4:53 PM, Steven Toth <stoth@linuxtv.org> wrote:
>>> Do you still see high BER and high UNC?
>>
>> I won't be able to try anything more until tomorrow evening.
>>
>> I think you're missing something, though, Steven.  The "In every case"
>> was in reference to "without an x50 installed and connected to cable".
>> That includes the cases where there are no x50s installed at all.  How
>> can the x50 encoder be causing noise when it's not even installed?
>
> I'm out of time. Someone else want to jump in and assist?
>
> - Steve

Given David's last summary of results, it seems like the BER indicator
for that particular demodulator is completely unreliable (which isn't
terribly surprising).  If you take that out of the equation, it seems
like the only time there is corruption is when both the 115 and the
x50 is encoding.

So, it seems like we're back to either an RF issue or a DMA issue.
Did David attempt to move the cards farther apart, or put any sort of
shielding between the two cards?  If the shielding has any effect,
then we're probably talking about an RF issue.  If it had no effect,
then we are probably talking about a DMA issue.

Either way, it seems like we should stop talking about the BER as any
sort of indicator of a problem.

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
