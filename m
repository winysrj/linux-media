Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:34227 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZF3T12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 15:27:28 -0400
Received: by qyk31 with SMTP id 31so426634qyk.33
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 12:27:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A4A64F9.6070807@linuxtv.org>
References: <200906301301.04604.gczerw@comcast.net>
	 <37219a840906301043q67e48d50nfc846ebf2158c05e@mail.gmail.com>
	 <200906301451.52933.gczerw@comcast.net> <4A4A64F9.6070807@linuxtv.org>
Date: Tue, 30 Jun 2009 15:27:30 -0400
Message-ID: <829197380906301227q52e7b215p359adaa3206dba79@mail.gmail.com>
Subject: Re: [linux-dvb] Hauppauge HVR-1800 not working at all
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Krufky <mkrufky@linuxtv.org>
Cc: gczerw@comcast.net,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 30, 2009 at 3:18 PM, Michael Krufky<mkrufky@linuxtv.org> wrote:
>> Mike, thanks for the reply.  Two questions...
>>
>> 1.  What do you mean by "spigots"?
>>
>> 2.  By the tuner module, do you mean the cx23885??
>>
>> Output of lsmod shows that cx25840, cx23885 & cx2341x are loaded
>>
>> cx25840                27856  0
>>         cx23885                85552  0
>>               cx2341x                12800  1 cx23885
>>                     videobuf_dma_sg        12160  1 cx23885
>>                           videobuf_dvb            6848  1 cx23885
>>                                 dvb_core               86112  1 videobuf_dvb
>>                                      videobuf_core          17888  3
>> cx23885,videobuf_dma_sg,videobuf_dvb              v4l2_common
>>  16220  3 cx25840,cx23885,cx2341x                           videodev
>>       40320  3 cx25840,cx23885,v4l2_common                       v4l1_compat
>>            13440  1 videodev
>>  btcx_risc               4772  1 cx23885
>>       tveeprom               11872  1 cx23885
>>
>
> Please, never remove cc from the public mailinglist.  (cc re-added)
>
> When I said 'tuner' module, I meant 'tuner' module :-P
>
> Hope this helps,
>
> Mike

To clarify Mike's point, he means there is a module called "tuner"
that you should see in the lsmod.  Also, when he refers to spigots, he
is referring to the F-connectors on the edge card that you would
connect the coax cable to.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
