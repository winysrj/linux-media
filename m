Return-path: <linux-media-owner@vger.kernel.org>
Received: from s250.sam-solutions.net ([217.21.49.219]:43901 "EHLO
	s250.sam-solutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3EQGmi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 02:42:38 -0400
Message-ID: <5195D159.6000501@sam-solutions.com>
Date: Fri, 17 May 2013 09:42:33 +0300
From: Andrei Andreyanau <a.andreyanau@sam-solutions.com>
Reply-To: a.andreyanau@sam-solutions.com
MIME-Version: 1.0
To: Chris MacGregor <chris@cybermato.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mt9p031 shows purple coloured capture
References: <5194D9AB.3030608@sam-solutions.com> <5194EF88.7070403@cybermato.com>
In-Reply-To: <5194EF88.7070403@cybermato.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Chris,

No, I didn't try this, but I'll try. Also I was thinking that this issue
appears because
the bus width is not 12 bits as needed by the datasheet, but 10 bits (as
it is limited
by the hardware) so I was thinking that it may cause this issue to appear.


Regards,
Andrei

On 05/16/2013 05:39 PM, Chris MacGregor wrote:
> Hi.  IIRC, I had this problem as well.  I think I "solved" it by 
> noticing that other users were simply skipping the first 3 frames. That 
> seems to consistently avoid the issue for me.  Have you tried that?
>
>      Chris
>
> On 05/16/2013 06:05 AM, Andrei Andreyanau wrote:
>> Hi, Laurent,
>> I have an issue with the mt9p031 camera. The kernel version I use
>> uses soc camera framework as well as camera does. And I have
>> the following thing which appears randomly while capturing the
>> image using gstreamer. When I start the capture for the first time, it
>> shows the correct image (live stream). When I stop and start it again
>> it may show the image in purple (it can appear on the third or fourth
>> time). Or it can show the correct image every time I start the capture.
>> Do you have any idea why it appears so?
>>
>> Thanks in advance,
>> Andrei Andreyanau
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

