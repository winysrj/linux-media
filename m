Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:49007 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbbBDLwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 06:52:55 -0500
Received: by mail-yh0-f42.google.com with SMTP id a41so462026yho.1
        for <linux-media@vger.kernel.org>; Wed, 04 Feb 2015 03:52:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54D1D01B.30201@xs4all.nl>
References: <54472CB702988260@smtp.movistar.es>
	<02ee01d031ec$283a80f0$78af82d0$@net>
	<006301d03b58$0181a9a0$0484fce0$@net>
	<006e01d03fe7$4cf3dd70$e6db9850$@net>
	<CALzAhNVjZh7nm5_3hGpSh4ZMsstja+M_2GLh2-15F0yp8QDOVw@mail.gmail.com>
	<54D1D01B.30201@xs4all.nl>
Date: Wed, 4 Feb 2015 06:52:54 -0500
Message-ID: <CALzAhNUQ=kNT7DoBH8Xu44KsRjqxPZxk+erdqJGDyAaA7UEUug@mail.gmail.com>
Subject: Re: [possible BUG, cx23885] Dual tuner TV card, works using one tuner
 only, doesn't work if both tuners are used
From: Steven Toth <stoth@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: dCrypt <dcrypt@telefonica.net>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> To my knowledge the driver is now stable. There is still the occasional
> kernel message that shouldn't be there which I am trying to track down,
> but the driver crashes due to a vb2 race condition have been fixed.

Thank you for the clarification Hans, and thanks for taking care of VB2 etc.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
