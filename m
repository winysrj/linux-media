Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:60544 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbZFBIHz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2009 04:07:55 -0400
Received: from pub3.ifh.de (pub3.ifh.de [141.34.15.119])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id n5287jwQ017997
	for <linux-media@vger.kernel.org>; Tue, 2 Jun 2009 10:07:45 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by pub3.ifh.de (Postfix) with ESMTP id F092D158191
	for <linux-media@vger.kernel.org>; Tue,  2 Jun 2009 10:07:44 +0200 (CEST)
Date: Tue, 2 Jun 2009 10:07:44 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-media@vger.kernel.org
Subject: Re: Terratec DT USB XS Diversity/DiB0070+vdr: "URB status: Value
 too large for defined data type"+USB reset
In-Reply-To: <4A244D3F.8050809@retrodesignfan.eu>
Message-ID: <alpine.LRH.1.10.0906021001440.31650@pub3.ifh.de>
References: <4A232498.2080202@retrodesignfan.eu> <4A244D3F.8050809@retrodesignfan.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marco,

On Mon, 1 Jun 2009, Marco Borm wrote:
> I "played" a little bit with my problem and tried the latest source from the 
> repository, but EOVERFLOW still occurs seconds after starting vdr.
> I activated the debug options of all, I hope, relevant modules now and got a 
> more detailed kern.log.
> Maybe some expert can help me and take look at it.
> Interesting section:
>
> Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
> Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
> Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
> Jun  1 23:16:14 vdr kernel: dmxdev: section callback 4e f2 6c 40 0a e7
> Jun  1 23:16:14 vdr kernel: dmxdev: section callback 50 f2 55 40 13 e1
> Jun  1 23:16:14 vdr kernel: dmxdev: section callback 00 b0 1d 03 01 d1
> Jun  1 23:16:14 vdr kernel: stop pid: 0x00a0, feedtype: 1
> Jun  1 23:16:14 vdr kernel: setting pid (no):   160 00a0 at index 7 'off'
> Jun  1 23:16:14 vdr kernel: function : dvb_dmxdev_filter_set
> Jun  1 23:16:14 vdr kernel: start pid: 0x00e0, feedtype: 1
> Jun  1 23:16:14 vdr kernel: setting pid (no):   224 00e0 at index 7 'on'
> Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
> Jun  1 23:16:14 vdr kernel: function : dvb_dvr_poll
> BOOM -> Jun  1 23:16:14 vdr kernel: urb completition error -75.

Hmm?!

>> This logs aren't very helpful, but I find something interesting with 
>> Wireshark and usbmon:
>> device -> host
>> URB type: URB_COMPLETE ('C')
>> URB transfer type: URB_BULK (3)
>> Endpoint: 0x83
>> Device: 13
>> Data: present (0)
>> URB status: Value too large for defined data type (-EOVERFLOW) (-75)
>> URB length [bytes]: 39424
>> Data length [bytes]: 39424
>> 
>> after this URB I get a "URB transfer type: URB_INTERRUPT (1)" and all goes 
>> to hell.
>> 
>> Its also  interesting that the URB+data length in the failure package is 
>> 39424 but "URB length [bytes]: 39480" in every package before that.

Definitely interesting. This is a known issue for the dib0700 device, 
which happens on some USB host controllers. Actually which one do you use?

>> As I know this device works without problems under linux for other people, 
>> so I'm wondering why. I searched but found nothing about such a problem.

Yeah, but are they using 2.6.29?

In fact, since 2 days I'm having the T5 Terratec device, which seems to be 
similar to your device, I'm going to try it soon. To experience whether 
there are similar problems.

Do you connect the device directly to the PC or is there an extension 
cable or another USB hub in between?

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
