Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.194]:54591 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0DRTTH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 15:19:07 -0400
Message-ID: <4BCB5B26.3080605@vorgon.com>
Date: Sun, 18 Apr 2010 12:19:02 -0700
From: "Timothy D. Lenz" <tlenz@vorgon.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: cx5000 default auto sleep mode
References: <4BC5FB77.2020303@vorgon.com>	 <k2h829197381004141040n4aa69e06x7a10c7ea70be3dcf@mail.gmail.com> <1271303099.7643.7.camel@palomino.walls.org>
In-Reply-To: <1271303099.7643.7.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 4/14/2010 8:44 PM, Andy Walls wrote:
> On Wed, 2010-04-14 at 13:40 -0400, Devin Heitmueller wrote:
>> On Wed, Apr 14, 2010 at 1:29 PM, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>>> Thanks to Andy Walls, found out why I kept loosing 1 tuner on a FusionHD7
>>> Dual express. Didn't know linux supported an auto sleep mode on the tuner
>>> chips and that it defaulted to on. Seems like it would be better to default
>>> to off.
>>
>> Regarding the general assertion that the power management should be
>> disabled by default, I disagree.  The power savings is considerable,
>> the time to bring the tuner out of sleep is negligible, and it's
>> generally good policy.
>>
>> Andy, do you have any actual details regarding the nature of the problem?
>
> Not really.  DViCo Fusion dual digital tv card.  One side of the card
> would yield "black video screen" when starting a digital capture
> sometime after (?) the VDR ATSC EPG plugin tried to suck off data.  I'm
> not sure there was a causal relationship.
>
> I hypothesized that one side of the dual-tuner was going stupid or one
> of the two channels used in the cx23885 was getting confused.  I was
> looking at how to narrow the problem down to cx23885 chip or xc5000
> tuner, or s5h14xx demod when I noted the power managment module option
> for the xc5000.  I suggested Tim try it.
>
> It was dumb luck that my guess actually made his symptoms go away.
>
> That's all I know.
>
> Regards,
> Andy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


Guess it only reduced the problem. Today I looked at the guide and abc 
had no data. Checked with femon and the second tuner on the dual would 
not tune.
