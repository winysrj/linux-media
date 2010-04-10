Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:48136 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab0DJMQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 08:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <20100410064801.GA2667@hardeman.nu>
References: <20100408113910.GA17104@hardeman.nu>
	 <1270812351.3764.66.camel@palomino.walls.org>
	 <s2o9e4733911004090531we8ff39b4r570e32fdafa04204@mail.gmail.com>
	 <4BBF3309.6020909@infradead.org> <20100410064801.GA2667@hardeman.nu>
Date: Sat, 10 Apr 2010 08:16:00 -0400
Message-ID: <y2t9e4733911004100516wf10a8c94lfb83e6503776222a@mail.gmail.com>
Subject: Re: [RFC3] Teach drivers/media/IR/ir-raw-event.c to use durations
From: Jon Smirl <jonsmirl@gmail.com>
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 10, 2010 at 2:48 AM, David Härdeman <david@hardeman.nu> wrote:
> On Fri, Apr 09, 2010 at 11:00:41AM -0300, Mauro Carvalho Chehab wrote:
>> struct {
>>       unsigned mark : 1;
>>       unsigned duration :31;
>> }
>>
>> There's no memory spend at all: it will use just one unsigned int and it is
>> clearly indicated what's mark and what's duration.
>
> If all three of you agree on this approach, I'll write a patch to convert
> ir-core to use it instead.

Fine with me.

>
> --
> David Härdeman
>



-- 
Jon Smirl
jonsmirl@gmail.com
