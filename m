Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35913 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbcAGPDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jan 2016 10:03:09 -0500
Received: by mail-qk0-f170.google.com with SMTP id q19so126020240qke.3
        for <linux-media@vger.kernel.org>; Thu, 07 Jan 2016 07:03:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <BY2PR20MB016823AC3F8916653DB47B11BDF50@BY2PR20MB0168.namprd20.prod.outlook.com>
References: <BY2PR20MB016823AC3F8916653DB47B11BDF50@BY2PR20MB0168.namprd20.prod.outlook.com>
Date: Thu, 7 Jan 2016 10:03:08 -0500
Message-ID: <CAGoCfix2v9PJK73s8qif4yaL86cBLsRrDpFm3tj30N2BpuKm7g@mail.gmail.com>
Subject: Re: Getting my Ion Video 2 PC to work
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?UTF-8?Q?Alexandre=2DXavier_Labont=C3=A9=2DLamoureux?=
	<alexandrexavier@live.ca>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

> Bus 001 Device 002: ID eb1a:5051 eMPIA Technology, Inc.

The fact that the board identifies with USB product ID 5051 makes me
wonder if perhaps they moved away from the tvp5150 and saa7113 (both
of which went EOL some time ago), and switched to the tvp5151 for the
video decoder.  Any chance you can take the unit apart and get some
photos?

What behavior are you seeing exactly with this device in terms of video?

Both Cheese and GUCView are targeted primarily at webcams, so they may
not work very well with generic video capture devices intended for TV
signals.  You might be better off trying an app like tvtime.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
