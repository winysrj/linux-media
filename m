Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4783 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaITKI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Sep 2014 06:08:56 -0400
Message-ID: <541D5220.4050107@xs4all.nl>
Date: Sat, 20 Sep 2014 12:08:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: James Harper <james@ejbdigital.com.au>,
	James Harper <james@maxsum.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: buffer delivery stops with cx23885
References: <778B08D5C7F58E4D9D9BE1DE278048B5C0B208@maxex1.maxsum.com> <541D469B.4000306@xs4all.nl> <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com>
In-Reply-To: <609d00f585384d999c8e3522fe1352ee@SIXPR04MB304.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2014 11:26 AM, James Harper wrote:
>>
>> On 09/20/2014 05:32 AM, James Harper wrote:
>>>
>>> My cx23885 based DViCO FusionHDTV DVB-T Dual Express2 (I submitted a
>>> patch for this a little while ago) has been working great but over
>>> the last few months it has started playing up. Nothing has really
>>> changed that I can put my finger on. Basically mythtv stops recording
>>> after a few minutes sometimes. Rarely when this happens I see some
>>> i2c errors but mostly not.
>>>
>>> With cx23885 debug options turned on (debug=9 vbi_debug=9
>> v4l_debug=9
>>> video_debug=9 irq_debug=9 ci_dbg=9) it seems like the card just stops
>>> delivering buffers (see dmesg output following). If I stop mythtv,
>>> all the buffers are cancelled (cx23885_stop_dma()) etc, and then
>>> restarting mythtv will get the recording going again, for a short
>>> time (minutes).
>>>
>>> Any suggestions to where I could start looking? Is it possible that
>>> my card itself is broken? (apart from this it's flawless).
>>
>> I see nothing wrong in the log, but you can try to use the current media_tree
>> code. The cx23885's DMA engine has effectively been rewritten there,
>> simplifying
>> the control flow.
>>
> 
> Oops I should have mentioned that. I'm using Debian "Jessie" with
> 3.16 kernel and already using the latest v4l as per link you sent (my
> DViCO FusionHDTV DVB-T Dual Express2 patch is in 3.17 I think, but
> that's not in Debian yet).

Ah, yes, that's rather important information :-)

I'll try to reproduce it.

How often does it happen?

I've setup a test where I just keep streaming to see if I can reproduce
it.

> 
> I think it only broke since the rewrite. Before that it seemed to be
> bulletproof. That was why I asked about the patch just before - I
> can't tell yet if the driver stops supplying data or if mythtv stops
> asking for data. If there was something funny about the poll loop
> then that could cause it. I suppose I can try and go back to an older
> version of the code and see what happens?

Can you test with the media_tree.git master branch, but going back to
commit 73d8102298719863d54264f62521362487f84256?

That has the cx23885 that has not yet been converted to vb2.

Test with that for a while to see if that works without problems. Then
go back to the HEAD of the master branch and try again.

If it breaks, then I may have to revert the cx23885 vb2 changes until I
figure out what's wrong.

Regards,

	Hans

> 
> Would the bug fixed by your "fix VBI/poll regression" patch cause
> intermittent stalls, or would the application that relied on the
> missing behaviour simply not work at all?
> 
> In any case I've just applied the patch and about to reboot.
> 
> Thanks
> 
> James
>
