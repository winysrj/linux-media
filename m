Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:55202 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669Ab3FSOVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jun 2013 10:21:20 -0400
Received: by mail-qe0-f43.google.com with SMTP id q19so3314053qeb.30
        for <linux-media@vger.kernel.org>; Wed, 19 Jun 2013 07:21:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
References: <1371393161.46485.YahooMailNeo@web163903.mail.gq1.yahoo.com>
	<8B18C28300FE4A6595829F526C5BA94A@SACWS001>
	<1371572315.65617.YahooMailNeo@web163901.mail.gq1.yahoo.com>
	<8737EBB72A154800A3A695B49F355F07@SACWS001>
	<1371587831.30761.YahooMailNeo@web163905.mail.gq1.yahoo.com>
	<7ED70E19F5604D7CA44DC92735A6BDE0@SACWS001>
	<20130618230655.GA23989@minime.bse>
	<1371648937.52293.YahooMailNeo@web163906.mail.gq1.yahoo.com>
Date: Wed, 19 Jun 2013 08:21:19 -0600
Message-ID: <CALzAhNUASfx7mGXaKcqhtQTkr=387Ta4Z6VwbKeF5n7T6CkrKA@mail.gmail.com>
Subject: Re: HD Capture Card (HDMI and Component) output raw pixels
From: Steven Toth <stoth@kernellabs.com>
To: James Board <jpboard2@yahoo.com>
Cc: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>,
	Steve Cookson <it@sca-uk.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> You are right.  According to your numbers, this card can't work.  So why
> would BlackMagic design an HDMI capture card with only one PCIe lane if it
> can't possibly work?   It must work somehow.  I must be missing some crucial
> piece of information.

Blackmagic's Intensity card doesn't support 1080p. None of the raw
video HD cards I've ever worked on do 1080p over pcie x1.

1080i max and it's 8 or 10bit colorspace, not 24bit (IIRC).

--
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
