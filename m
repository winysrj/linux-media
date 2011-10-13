Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nexicom.net ([216.168.96.13]:55049 "EHLO smtp.nexicom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab1JMXts (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 19:49:48 -0400
Received: from mail.lockie.ca (dyn-dsl-mb-216-168-118-207.nexicom.net [216.168.118.207])
	by smtp.nexicom.net (8.13.6/8.13.4) with ESMTP id p9DNnk4s006056
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 19:49:47 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by mail.lockie.ca (Postfix) with ESMTP id B29B81E0229
	for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 19:49:45 -0400 (EDT)
Message-ID: <4E977919.5060102@lockie.ca>
Date: Thu, 13 Oct 2011 19:49:45 -0400
From: James <bjlockie@lockie.ca>
MIME-Version: 1.0
To: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: help with azap
References: <4E972A8F.2020004@lockie.ca> <CAGoCfiygsxpA_qpoJ=BJ2YorqRPxg8ooMhvTMqscoxH1m+rh6A@mail.gmail.com>
In-Reply-To: <CAGoCfiygsxpA_qpoJ=BJ2YorqRPxg8ooMhvTMqscoxH1m+rh6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/13/11 14:30, Devin Heitmueller wrote:
> On Thu, Oct 13, 2011 at 2:14 PM, James<bjlockie@lockie.ca>  wrote:
>> $ more channels.conf
>> CIII-HD:85000000:8VSB:49:52+53:1
>> OTTAWA CBOFT-DT:189000000:8VSB:49:53+52:3
>> CJOH:213000000:8VSB:49:51+52:1
>> TVO    :533000000:8VSB:49:52+53:1
>> OTTAWA  CBOT-DT:539000000:8VSB:49:52+53:3
>> Télé-Québec_HD:569000000:8VSB:49:52+53:3
>> CHOT:629000000:8VSB:49:52:3
>
>> What does "ERROR: error while parsing Audio PID (not a number)" mean?
> I don't know where your channels.conf came from, but it appears to be
> malformed.  You cannot have "52+53" as the audio PID.  If you just
> want to get up and running, remove the "+53" part.
>
> Devin
>
I used:
w_scan -f a -c US -M
(mplayer format)

I redid it with:
w_scan -f a -c US -X
(czap/tzap/szap/xine)
and got:
CIII-HD:85000000:8VSB:49:52:1
OTTAWA CBOFT-DT:189000000:8VSB:49:53:3
CJOH:213000000:8VSB:49:51:1
TVO    :533000000:8VSB:49:52:1
OTTAWA  CBOT-DT:539000000:8VSB:49:52:3
Télé-Québec_HD:569000000:8VSB:49:52:3
CHOT:629000000:8VSB:49:52:3

It is weird there is not a standard format. :-)

