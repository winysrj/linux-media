Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01.rbsworldpay.com ([193.41.220.65]:22288 "EHLO
	mail01.rbsworldpay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZLJOhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 09:37:18 -0500
Message-ID: <4B2107A3.6010004@rbsworldpay.com>
Date: Thu, 10 Dec 2009 14:37:23 +0000
From: Ian Richardson <ian.richardson@rbsworldpay.com>
MIME-Version: 1.0
To: Thomas Kernen <tkernen@deckpoint.ch>
CC: =?UTF-8?B?TWF0dGhpYXMgV8OkY2h0ZXI=?= <matthias@waechter.wiz.at>,
	linux-media@vger.kernel.org
Subject: Re: TBS 6980 Dual DVB-S2 PCIe card
References: <4B167A32.7000509@deckpoint.ch> <4B1E2243.2070306@waechter.wiz.at> <4B1E551C.6090307@deckpoint.ch> <4B1E6BD4.2060204@rbsworldpay.com> <4B1FC1F5.60109@deckpoint.ch>
In-Reply-To: <4B1FC1F5.60109@deckpoint.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2009-12-09 15:27, Thomas Kernen wrote:
> Ian Richardson wrote:
>> On 2009-12-08 13:31, Thomas Kernen wrote:
>>> Matthias Wächter wrote:
>>>> Hallo Thomas!
>>>>
>>>> Am 02.12.2009 15:31, schrieb Thomas Kernen:
>>>>> Is someone already working on supporting the TBS 6980 Dual DVB-S2 
>>>>> PCIe
>>>>> card? http://www.tbsdtv.com/english/product/6980.html

I can now confirm it works fine with MythTV 0.22 and at least their 
version of V4L. I tripped up on the known backend defect where you can't 
obviously select the DiSEqC config. See 
https://bugs.launchpad.net/mythtv/+bug/452894 for more info, and the 
workaround.

Thanks,

Ian

