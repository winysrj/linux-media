Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46983 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab2HZTw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Aug 2012 15:52:59 -0400
Received: by lbbgj3 with SMTP id gj3so2124975lbb.19
        for <linux-media@vger.kernel.org>; Sun, 26 Aug 2012 12:52:58 -0700 (PDT)
Message-ID: <503A7E98.9030404@gmail.com>
Date: Sun, 26 Aug 2012 21:52:56 +0200
From: =?ISO-8859-1?Q?Roger_M=E5rtensson?= <roger.martensson@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Terratec H7 aka az6007 with CI
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

Just a reminder that az6007 with CI still isn't working 100% with Kaffeine.
But since I use my device with MythTV that uses the same usage pattern 
as my workaround for Kaffeine it works like a charm.

The pattern are:
* Open up device / Start Kaffeine
* Tune to encrypted channel / Choose channel in Kaffeine
* Close Device / Close Kaffeine
* Open device / Start Kaffeine
* Watch channel

The exact procedure that MythTV uses when tuning to a channel.

Not exactly sure if this is a driver bug or a Kaffeine bug since I'm 
just a user.

The "normal" way that do not work in Kaffeine are:
* Start Kaffeine
* Tune to an encrypted channel
* If that works tune to another encrypted channel which will not work.

Since it is working with my main application I'm satisfied but look at 
this as a formal bug report. If you need any help or testing I'm willing 
to help time permitting. I know that some of you doing the actual work 
doesn't have access to a CAM but if you need debugging information or 
any output just notify me directly.

I'm am running a relativly new media_build. Haven't been able to test 
the latest media_build since it is stopping on a compile error. (As of 
25 of August 2012)

Thanks again for the hard work with the driver (Mauro for the inclusion 
and Jose for the CI. Hopefully I got the names right).

It is much appreciated by me and my better half.
