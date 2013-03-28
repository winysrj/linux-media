Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:35009 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3C1IvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 04:51:08 -0400
Received: by mail-ea0-f171.google.com with SMTP id b15so1719936eae.30
        for <linux-media@vger.kernel.org>; Thu, 28 Mar 2013 01:51:07 -0700 (PDT)
Date: Thu, 28 Mar 2013 10:52:01 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Timo Teras <timo.teras@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Terratec Grabby hwrev 2
Message-ID: <20130328105201.7bcc7388@vostro>
In-Reply-To: <20130327161049.683483f8@vostro>
References: <20130325190846.3250fe98@vostro>
	<20130325143647.3da1360f@redhat.com>
	<20130325194820.7c122834@vostro>
	<20130325153220.3e6dbfe5@redhat.com>
	<20130325211238.7c325d5e@vostro>
	<20130326102056.63b55916@vostro>
	<20130327161049.683483f8@vostro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 Mar 2013 16:10:49 +0200
Timo Teras <timo.teras@iki.fi> wrote:

> On Tue, 26 Mar 2013 10:20:56 +0200
> Timo Teras <timo.teras@iki.fi> wrote:
> 
> > I did manage to get decent traces with USBlyzer evaluation version.
> 
> Nothing _that_ exciting there. Though, there's quite a bit of
> differences on certain register writes. I tried copying the changed
> parts, but did not really help.
> 
> Turning on saa7115 debug gave:
> 
> saa7115 1-0025: chip found @ 0x4a (ID 000000000000000) does not match
> a known saa711x chip.

Well, I just made saa7115.c ignore this ID check, and defeault to
saa7113 which is apparently the chip used.

And now it looks like things start to work a lot better.

Weird that the saa7113 chip is missing the ID string. Will continue
testing.

- Timo
