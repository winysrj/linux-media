Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:38423 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZBRPQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 10:16:45 -0500
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KF9004T5P3VVLU0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 18 Feb 2009 10:16:44 -0500 (EST)
Date: Wed, 18 Feb 2009 10:16:43 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: PVR x50 corrupts ATSC 115 streams
In-reply-to: <412bdbff0902171438u7c2ab531y62bb6c717647e917@mail.gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: David Engel <david@istwok.net>, linux-media@vger.kernel.org,
	V4L <video4linux-list@redhat.com>
Message-id: <499C265B.9010309@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20090217155335.GB6196@opus.istwok.net>
 <499AE054.6020608@linuxtv.org> <20090217201740.GA9385@opus.istwok.net>
 <499B1E19.80302@linuxtv.org> <20090217205629.GA9722@opus.istwok.net>
 <412bdbff0902171305j26827e3fp2852f3774a788a67@mail.gmail.com>
 <499B3A60.90306@linuxtv.org>
 <412bdbff0902171438u7c2ab531y62bb6c717647e917@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Tue, Feb 17, 2009 at 5:29 PM, Steven Toth <stoth@linuxtv.org> wrote:
>> The driver is probably buggy. Either its really reporting pre-viterbi errors
>> OR it's reporting real post-viterbi errors - but in which case why aren't we
>> also measuring uncorrected blocks?
>>
>> Regardless of Davids actual current problem, this sounds like a secondary
>> unrelated issue.
>>
>> - Steve
> 
> Sorry, I didn't intend to suggest that the BER code isn't buggy - just
> that I doubt it has any bearing on his actual problem since they occur
> regardless of whether the other cards are running.

Agreed, probably a secondary issue - which probably needs some attention regardless.

I don't follow kworld products so I don't pretend to know which demod they're 
using. I guess my question to the wider audience is, do people with this same 
demod on other cards experience similar BER issues.

- Steve
