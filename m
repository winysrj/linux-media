Return-path: <mchehab@gaivota>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:46705 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab0LNTvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 14:51:04 -0500
Received: from TheShoveller.local
 (ool-4572125f.dyn.optonline.net [69.114.18.95]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0LDF00847OH21590@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 14 Dec 2010 14:51:03 -0500 (EST)
Date: Tue, 14 Dec 2010 14:51:02 -0500
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge HVR-2200 analog
In-reply-to: <4D07A829.6080406@jusst.de>
To: Julian Scheel <julian@jusst.de>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Message-id: <4D07CAA6.3030300@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
References: <4CFE14A1.3040801@jusst.de>
 <1291726869.2073.5.camel@morgan.silverblock.net> <4D07A829.6080406@jusst.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/14/10 12:23 PM, Julian Scheel wrote:
> Is there any reason, why the additional card-information found here:
> http://www.kernellabs.com/hg/~stoth/saa7164-dev/
> is not yet in the kernel tree?

On my todo list.

I validate each board before I add its profile to the core tree. If certain
boards are missing then its because that board is considered experimental or is
pending testing and merge.

PAL encoder support is broken in the current tree and it currently getting my
love and attention. Point me at the specific boards you think are missing and
I'll also add these to my todo list, they'll likely get merged at the same time.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com


