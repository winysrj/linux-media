Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48419 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1AQRrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 12:47:52 -0500
Received: by qwa26 with SMTP id 26so4996882qwa.19
        for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 09:47:51 -0800 (PST)
References: <20110117124537.202100@gmx.net>
In-Reply-To: <20110117124537.202100@gmx.net>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <FDABB74D-7D9C-4C40-B99F-8CAF33EBE3EA@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Apple remote support
Date: Mon, 17 Jan 2011 12:48:05 -0500
To: a.bahr@mailueberfall.de
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 17, 2011, at 7:45 AM, a.bahr@mailueberfall.de wrote:

> I am using the current git version of Linux 2.6 and I was wondering if somebody is still working on Apple remote support?
> 
> I've found this patch[1] which seems to add support for the Apple remote, but it does not compile any more with the current git tree.
> 
> The Apple remote is a very popular device and it would be nice if the mainline kernel would support it.

Its still on my TODO list. There are a few implementation details that
need to be ironed out still, but other IR work has taken priority over
this, for the moment...

-- 
Jarod Wilson
jarod@wilsonet.com



