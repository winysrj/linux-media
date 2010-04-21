Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3836 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab0DUGhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 02:37:46 -0400
Message-ID: <ee20bb7da9d2708352bb7236108294d5.squirrel@webmail.xs4all.nl>
Date: Wed, 21 Apr 2010 08:37:39 +0200
Subject: Re: av7110 and budget_av are broken!
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "e9hack" <e9hack@googlemail.com>
Cc: linux-media@vger.kernel.org,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Am 22.3.2010 20:34, schrieb e9hack:
>> Am 20.3.2010 22:37, schrieb Hans Verkuil:
>>> On Saturday 20 March 2010 17:03:01 e9hack wrote:
>>> OK, I know that. But does the patch I mailed you last time fix this
>>> problem
>>> without causing new ones? If so, then I'll post that patch to the list.
>>
>> With your last patch, I've no problems. I'm using a a TT-C2300 and a
>> Budget card. If my
>> VDR does start, currently I've no chance to determine which module is
>> load first, but it
>> works. If I unload all modules and load it again, I've no problem. In
>> this case, the
>> modules for the budget card is load first and the modules for the FF
>> loads as second one.
>
> Ping!!!!!!

It's merged in Mauro's fixes tree, but I don't think those pending patches
have been pushed upstream yet. Mauro, can you verify this? They should be
pushed to 2.6.34!

Regards,

        Hans 'still stuck in San Francisco' Verkuil

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

