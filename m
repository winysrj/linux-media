Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]:54424
	"EHLO alefors.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZKMSCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 13:02:38 -0500
Received: from [10.0.0.11] ([10.0.0.11]:55422)
	by alefors.se with [XMail 1.26 ESMTP Server]
	id <S41C> for <linux-media@vger.kernel.org> from <magnus@alefors.se>;
	Fri, 13 Nov 2009 19:02:41 +0100
Message-ID: <4AFD9F39.5010808@alefors.se>
Date: Fri, 13 Nov 2009 19:02:33 +0100
From: =?UTF-8?B?TWFnbnVzIEjDtnJsaW4=?= <magnus@alefors.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Most stable DVB-S2 PCI Card?
References: <72748420-1243012937-cardhu_decombobulator_blackberry.rim.net-428520223-@bxe1214.bisx.prod.on.blackberry> <1a297b360905221035ra3ddfe3vb3be4d2029865a39@mail.gmail.com> <4AFCB38D.3050301@closetothewind.net>
In-Reply-To: <4AFCB38D.3050301@closetothewind.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jonas Kvinge wrote:
> Manu Abraham wrote:
>   
>> On Fri, May 22, 2009 at 9:23 PM, Bob Ingraham <bobi@brin.com> wrote:
>>     
>>> Hello,
>>>
>>> What is the most stable DVB-S2 PCI card?
>>>
>>> I've read through the wiki DVB-2 PCI section, but am not confident after reading this what the answer is.
>>>
>>> Running Fedora Core 10 at the moment, but am willing to upgrade to 11 or perform custom patches to get something going.
>>>
>>> No need for CI or DiSEQ support, just highly stable/reliable DVB-2 tuning/reception under Linux.
>>>
>>> Any recommendations would be most appreciated!
>>>
>>>       
>> If you don't need the CI part, The TT S2-1600 is a 2nd generation DVB-S2 PCI
>> card with great performance (supports Symbol rates upto 60MSPS), with support
>> out of the box from the v4l-dvb tree.
>>
>> Regards,
>> Manu
>>     
>
> I think I will try that card. Is the card tested to be working by many?
>
>
> Jonas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
I have four of them and they work perfectly, but not out of the box from
the v4l-dvb tree. If it's patched with the patches posted on this list a
few weeks ago by Andreas Regel (or used with his repo at
http://powarman.dyndns.org/hg/v4l-dvb) it locks perfectly on every
transonder on 1.0W, without them it does not. I also have an S2-3200 and
a NOVA-HD-S2 but they can't handle all transponders symbol rates so I
highly recommend the S2-1600. Bought them for <Ã¢ÂÂ¬50 in Germany.

/Magnus H




