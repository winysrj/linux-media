Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:50754 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032422Ab2CPAQP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 20:16:15 -0400
Message-ID: <4F62864B.3090207@ukfsn.org>
Date: Fri, 16 Mar 2012 00:16:11 +0000
From: Andy Furniss <andyqos@ukfsn.org>
MIME-Version: 1.0
To: Keith Edmunds <kae@midnighthax.com>
CC: linux-media@vger.kernel.org
Subject: Re: cxd2820r: i2c wr failed (PCTV Nanostick 290e)
References: <20120310142042.0f238d3a@ws.the.cage> <20120315201446.17f21639@ws.the.cage>
In-Reply-To: <20120315201446.17f21639@ws.the.cage>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Keith Edmunds wrote:
> I posted the message below last week, but I've had no response.
>
> Is this the wrong list? Did I do something wrong in my posting?
>
> I would like fix this problem, and I have more information now, but I
> don't want to clutter this list if it's the wrong place.
>
> Guidance as to what I should do gratefully received: thanks.

>> Mar  9 10:02:03 woodlands kernel: [ 6006.157991] cxd2820r: i2c wr failed
>> ret:-110 reg:85 len:1

Just another 290e user here, but I also think this could be a usb issue.

My 290e is on an old PC, so I had to buy a usb2 card for it. The first 
one I bought was useless - really bad and I have lots of errors like 
that logged over the couple of days before I got a different make.

I have none since. I doubt yours is quite as obviously broken as mine 
was (I could tune, but vid was full of errors, though it did play).

One test which may show up that your USB is the problem is to put a gig 
file on a usb stick and repeatedly md5sum it. To avoid reading disk 
cache from ram rather than from stick you need to umount then mount 
between runs (maybe echo 3 > /proc/sys/vm/drop_caches would also work - 
you can judge by how long it takes). Mine would never give the same sum 
twice - I doubt yours will be that bad.








