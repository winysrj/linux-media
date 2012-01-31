Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:41914 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704Ab2AaPA2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 10:00:28 -0500
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de> <1327960820-11867-6-git-send-email-danny.kukawka@bisect.de> <201201311445.20095.danny.kukawka@bisect.de>
In-Reply-To: <201201311445.20095.danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 05/16] cx18: fix handling of 'radio' module parameter
From: Andy Walls <awalls@md.metrocast.net>
Date: Tue, 31 Jan 2012 09:59:32 -0500
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>, mchehab@redhat.com
Message-ID: <149fa4c4-616c-4c3d-8ad4-bf7be9c6d35c@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Danny Kukawka <danny.kukawka@bisect.de> wrote:

>On Dienstag, 31. Januar 2012, Andy Walls wrote:
>> On Tue, 2012-01-31 at 05:01 -0500, Andy Walls wrote:
>> > On Mon, 2012-01-30 at 20:40 +0100, Danny Kukawka wrote:
>> > > Fixed handling of 'radio' module parameter from
>module_param_array
>> > > to module_param_named to fix these compiler warnings in
>cx18-driver.c:
>> >
>> > NACK.
>> >
>> > "radio" is an array of tristate values (-1, 0, 1) per installed
>card:
>> >
>> > 	static int radio[CX18_MAX_CARDS] = { -1, -1,
>> >
>> > and must remain an array or you will break the driver.
>> >
>> > Calling "radio_c" a module parameter named "radio" is wrong.
>> >
>> > The correct fix is to reverse Rusty Russel's patch to the driver in
>> > commit  90ab5ee94171b3e28de6bb42ee30b527014e0be7
>> > to change the "bool" back to an "int" as it should be in
>>
>>                       ^^^^
>> Sorry, a typo here.  Disregard the word "back".
>
>Overseen this. But wouldn't be the correct fix in this case to:
>a) reverse the part of 90ab5ee94171b3e28de6bb42ee30b527014e0be7 to:
>   get: 
>   static unsigned radio_c = 1;
>   
>b) change the following line:
>   module_param_array(radio, bool, &radio_c, 0644);
>   to:
>   module_param_array(radio, int, &radio_c, 0644);
>
>Without b) you would get a warning from the compiler again.
>
>Danny 

Yes, both need to happen.

I mentioned b) at the end of my original email.

Regards,
Andy
