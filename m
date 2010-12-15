Return-path: <mchehab@gaivota>
Received: from smtp.work.de ([212.12.45.188]:54454 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab0LOHEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 02:04:54 -0500
Subject: Re: Hauppauge HVR-2200 analog
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Julian Scheel <julian@jusst.de>
In-Reply-To: <4D07CAA6.3030300@kernellabs.com>
Date: Wed, 15 Dec 2010 08:04:50 +0100
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <67DB049D-B91E-4457-93CE-2CE0164C5B54@jusst.de>
References: <4CFE14A1.3040801@jusst.de> <1291726869.2073.5.camel@morgan.silverblock.net> <4D07A829.6080406@jusst.de> <4D07CAA6.3030300@kernellabs.com>
To: Steven Toth <stoth@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 14.12.2010 um 20:51 schrieb Steven Toth:

> On 12/14/10 12:23 PM, Julian Scheel wrote:
>> Is there any reason, why the additional card-information found here:
>> http://www.kernellabs.com/hg/~stoth/saa7164-dev/
>> is not yet in the kernel tree?
> 
> On my todo list.

Ok, fine.

> I validate each board before I add its profile to the core tree. If certain
> boards are missing then its because that board is considered experimental or is
> pending testing and merge.
> 
> PAL encoder support is broken in the current tree and it currently getting my
> love and attention. Point me at the specific boards you think are missing and
> I'll also add these to my todo list, they'll likely get merged at the same time.

Actually this is the board I am testing with:
http://www.kernellabs.com/hg/~stoth/saa7164-dev/rev/cf2d7530d676

Should it work with your testing tree or is the encoder part broken there as well?

Julian