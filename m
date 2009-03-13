Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f165.google.com ([209.85.217.165]:43213 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZCMWbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 18:31:17 -0400
Received: by gxk9 with SMTP id 9so454053gxk.13
        for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 15:31:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a3ef07920903131527x2762f6e6y18f3a0b825ff2a49@mail.gmail.com>
References: <49B9BC93.8060906@nav6.org>
	 <a3ef07920903121923r77737242ua7129672ec557a97@mail.gmail.com>
	 <49B9DECC.5090102@nav6.org>
	 <412bdbff0903130727p719b63a0u3c4779b3bec7520b@mail.gmail.com>
	 <Pine.LNX.4.58.0903131404430.28292@shell2.speakeasy.net>
	 <412bdbff0903131432r1233ab67sb7327638f7cf1e02@mail.gmail.com>
	 <37219a840903131452mf8b7969h881a24fc2dd031e8@mail.gmail.com>
	 <a3ef07920903131527x2762f6e6y18f3a0b825ff2a49@mail.gmail.com>
Date: Fri, 13 Mar 2009 18:31:14 -0400
Message-ID: <412bdbff0903131531y3dcb5382red13ac1e4d43feaf@mail.gmail.com>
Subject: Re: The right way to interpret the content of SNR, signal strength
	and BER from HVR 4000 Lite
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: VDR User <user.vdr@gmail.com>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Ang Way Chuang <wcang@nav6.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2009 at 6:27 PM, VDR User <user.vdr@gmail.com> wrote:
> Just wanted to comment that I'm glad there is a lot of interest in
> this.  I've heard endless talk & confusion on the user end over the
> years as to the accuracy of the values, or in some cases (as with
> Genpix adapters for example) where you don't seem to get any useful
> information.  Of course making it really hard for people who are
> trying to aim dishes and the like in the case of dvb-s*.
>
> A quick question about implimenting this though..  What's the most
> difficult component?

Hello,

There are basically two "difficult components"

1.  Getting everyone to agree on a standard representation for the
field, and how to represent certain error conditions (such as when a
demod doesn't support SNR, or when it cannot return a valid value at a
given time).

2.  Converting all the drivers to the agreed-upon format.  For some
drivers this is relatively easy as we have specs available for how the
SNR is represented.  For others, the value displayed is entirely
reverse engineered so the current representations are completely
arbitrary.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
