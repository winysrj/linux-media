Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2625 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaITLPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 07:15:47 -0400
Message-ID: <541D61D7.3080202@xs4all.nl>
Date: Sat, 20 Sep 2014 13:15:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com> <541D469B.4000306@xs4all.nl> <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5220.4050107@xs4all.nl> <a349a970f1d445538b52eb4d0e98ee2c@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5CD0.1000207@xs4all.nl> <9cc65ceabd05475d89a92c5df04cc492@SIXPR04MB304.apcprd04.prod.outlook.com>
In-Reply-To: <9cc65ceabd05475d89a92c5df04cc492@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2014 01:05 PM, James Harper wrote:
>>> I was looking through the patches and saw a date of August 14 on the
>>> cx23885 to vb2 patch and thought that could have been around when it
>>> started breaking, but then the
>>> 73d8102298719863d54264f62521362487f84256 is dated September 3 and I'm
>>> pretty sure it had started playing up before then. About what date
>>> would I have seen the 453afdd9ce33293f640e84dc17e5f366701516e8
>>> "cx23885: convert to vb2" patch?
>>
>> That patch was merged in the master branch September 8.
>>
>> If you've seen it earlier, then it may not be related to vb2 after all.
>>
> 
> I'd say not.
> 
>> If it is polling related, then it might be commit
>> 9241650d62f79a3da01f1d5e8ebd195083330b75
>> (Don't return POLLERR during transient buffer underruns) which was added
>> to
>> the master branch on July 17th and was merged for 3.17. Or it could be
>> something entirely different.
>>
>> You could try reverting that commit and see if that helps.
> 
> That sounds plausible wrt timeframe, but if cx23885 only started using vb2 after Sept 8 then it couldn't have affected me before then right?

You are right about that. You are using DVB right? Not analog video? (Just to
be 100% certain).

> 
>>> In any case it should be easy enough to revert and build so I'll do
>>> that tomorrow once I can prove it still fails with the current
>>> regression patch applied.
>>
>> Which patch are you using? There have been several versions posted. This
>> is the one you should use:
>>
>> https://patchwork.linuxtv.org/patch/25992/
>>
> 
> That's the one I applied - you can even see my questions below in that link :) Based on what you have said I think that's not going to solve anything for me though.

If you are streaming DVB, then that patch has no effect since the vb2_poll call will
never be called for DVB anyway, so that can be ruled out.

> 
> So I guess my plan is:
> . Revert to 73d8102298719863d54264f62521362487f84256 and test (not likely to fix but easy to test)

And important for me, because if it IS related to the vb2 conversion then I need to know asap.

My own streaming test is still running strong (not using MythTV BTW).

> . Revert to sometime around June when I submitted my patch for Fusion Dual Express 2 driver when I know it was reliable and test
> 
> Other possibilities are:
> . MythTV bug
> . Defective card
> 
> Time to google a command line dvb stream to rule out mythtv I guess...

Regards,

	Hans

