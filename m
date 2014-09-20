Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1439 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaITKyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:54:22 -0400
Message-ID: <541D5CD0.1000207@xs4all.nl>
Date: Sat, 20 Sep 2014 12:54:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com> <541D469B.4000306@xs4all.nl> <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com> <541D5220.4050107@xs4all.nl> <a349a970f1d445538b52eb4d0e98ee2c@SIXPR04MB304.apcprd04.prod.outlook.com>
In-Reply-To: <a349a970f1d445538b52eb4d0e98ee2c@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2014 12:30 PM, James Harper wrote:
>>> Oops I should have mentioned that. I'm using Debian "Jessie" with
>>> 3.16 kernel and already using the latest v4l as per link you sent (my
>>> DViCO FusionHDTV DVB-T Dual Express2 patch is in 3.17 I think, but
>>> that's not in Debian yet).
>>
>> Ah, yes, that's rather important information :-)
>>
>> I'll try to reproduce it.
>>
>> How often does it happen?
>>
>> I've setup a test where I just keep streaming to see if I can reproduce
>> it.
>>
> 
> Happens within 5 minutes some nights (and reliably within 1 minute
> when I was testing with all the printk turned on), then not for hours
> other nights. Right now it hasn't crashed since I applied the
> VBI/poll regression patch (my kids are recording a few movies so I
> think I'd be in trouble if I tinkered with it any more tonight :)
> 
> That's a fairly common pattern though - plays up when the kids are
> recording their afternoon shows when they get home from school, but
> then is often fairly stable after around 8pm when movies start. I
> can't really make sense of it. Someone mentioned seeing a few
> oddities when mythtv was busy downloading EIT guide but I can see
> when that happens and there isn't a correlation.
>  
>>> I think it only broke since the rewrite. Before that it seemed to be
>>> bulletproof. That was why I asked about the patch just before - I
>>> can't tell yet if the driver stops supplying data or if mythtv stops
>>> asking for data. If there was something funny about the poll loop
>>> then that could cause it. I suppose I can try and go back to an older
>>> version of the code and see what happens?
>>
>> Can you test with the media_tree.git master branch, but going back to
>> commit 73d8102298719863d54264f62521362487f84256?
>>
>> That has the cx23885 that has not yet been converted to vb2.
>>
>> Test with that for a while to see if that works without problems. Then
>> go back to the HEAD of the master branch and try again.
>>
>> If it breaks, then I may have to revert the cx23885 vb2 changes until I
>> figure out what's wrong.
>>
> 
> I was looking through the patches and saw a date of August 14 on the
> cx23885 to vb2 patch and thought that could have been around when it
> started breaking, but then the
> 73d8102298719863d54264f62521362487f84256 is dated September 3 and I'm
> pretty sure it had started playing up before then. About what date
> would I have seen the 453afdd9ce33293f640e84dc17e5f366701516e8
> "cx23885: convert to vb2" patch?

That patch was merged in the master branch September 8.

If you've seen it earlier, then it may not be related to vb2 after all.

If it is polling related, then it might be commit 9241650d62f79a3da01f1d5e8ebd195083330b75
(Don't return POLLERR during transient buffer underruns) which was added to
the master branch on July 17th and was merged for 3.17. Or it could be
something entirely different.

You could try reverting that commit and see if that helps.

> 
> In any case it should be easy enough to revert and build so I'll do
> that tomorrow once I can prove it still fails with the current
> regression patch applied.

Which patch are you using? There have been several versions posted. This
is the one you should use:

https://patchwork.linuxtv.org/patch/25992/

Regards,

	Hans
