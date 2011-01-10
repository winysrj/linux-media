Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53610 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab1AJTvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 14:51:07 -0500
Received: by qyk12 with SMTP id 12so22348560qyk.19
        for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 11:51:06 -0800 (PST)
References: <65DE7931C559BF4DBEE42C3F8246249A0B686EB0@V-EXMAILBOX.ctg.com> <8AFBEFD7-69E3-4E71-B155-EA773C2FED43@wilsonet.com> <1294661533.2084.14.camel@morgan.silverblock.net>
In-Reply-To: <1294661533.2084.14.camel@morgan.silverblock.net>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <074ED53E-2C56-4642-99D5-CD96C8B647D8@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: Jason Gauthier <jgauthier@lastar.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Janne Grunau <j@jannau.net>
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: Maybe I'll hack on lirc_zilog.c this coming weekend (Re: Enable IR on hdpvr)
Date: Mon, 10 Jan 2011 14:51:15 -0500
To: Andy Walls <awalls@md.metrocast.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Jan 10, 2011, at 7:12 AM, Andy Walls wrote:

> On Mon, 2011-01-10 at 01:05 -0500, Jarod Wilson wrote:
>> On Jan 9, 2011, at 7:36 PM, Jason Gauthier wrote:
> 
>> There's a bit more to it than just the one line change. Here's the patch we're
>> carrying in the Fedora kernels to enable it:
>> 
>> http://wilsonet.com/jarod/lirc_misc/hdpvr-ir/hdpvr-ir-enable.patch
>> 
> 
> BTW, I plan to work on lirc_zilog.c this coming weekend, with my PVR-150
> and HVR-1600 as test units.  If there are any lirc_zilog.c patches you
> have developed that are not in the media_tree.git repo, could you point
> me to them before then?

Don't have any, so you should be good to go.

/me still needs to do further testing w/the hdpvr and hvr-1950...

-- 
Jarod Wilson
jarod@wilsonet.com



