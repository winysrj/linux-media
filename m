Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:55846 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZFVXZG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 19:25:06 -0400
Date: Mon, 22 Jun 2009 18:39:55 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@radix.net>
cc: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: Re: lsmod path hardcoded in v4l/Makefile
In-Reply-To: <1245710531.3190.7.camel@palomino.walls.org>
Message-ID: <alpine.LNX.2.00.0906221833160.24027@banach.math.auburn.edu>
References: <200906221636.25006.zzam@gentoo.org> <1245710531.3190.7.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 22 Jun 2009, Andy Walls wrote:

> On Mon, 2009-06-22 at 16:36 +0200, Matthias Schwarzott wrote:
>> Hi list!
>>
>> It seems the path to lsmod tool is hardcoded in the Makefile for out-of-tree
>> building of v4l-dvb.
>> Now at least gentoo has moved lsmod from /sbin to /bin.

Sorry, but is it considered impertinent to ask why that lsmod should be 
moved from /sbin (system binaries, and lsmod certainly is one of those) 
and stick it into /bin instead? Is there any cogent reason for doing a 
thing like that, which may have escaped my attention? Unless one is making 
some very small distro for some very small hardware and (say) one of /bin 
and /sbin is symlinked to the other, I find a change like that to be 
extremely puzzling. So, really. Why?

Theodore Kilgore
