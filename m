Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:65324 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZDAH1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 03:27:01 -0400
Date: Wed, 1 Apr 2009 09:26:19 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Dominik Sito <railis@juvepoland.com>
cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Does skystar dvb usb2 card work in linux ?
In-Reply-To: <200903312004.45039.railis@juvepoland.com>
Message-ID: <alpine.LRH.1.10.0904010922440.21921@pub4.ifh.de>
References: <267bb6670903311039j7d37afcelf66d6a9cecd3637c@mail.gmail.com> <200903312004.45039.railis@juvepoland.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dominik,

On Tue, 31 Mar 2009, Dominik Sito wrote:

> Tuesday 31 March 2009 19:39:28 a dehqan napisa?(a):
>> In The Name Of God
>>
>> I'll be thankfull if you guide ;
>> Does skystar dvb usb2 card work in linux ?Does it have linux driver ?
>> has anyone tested it ?
>>
>> regards dehqan
>
> I think it's still undone. I have not clear information, but there would be
> any information about that. I'm not sure, but flexcop-usb isn't
> supported by USB 2.0. If i'm wrong please enlight me.
> Regards

As of today there is no support for the USB2 version of Technisat's 
device. Technisat is not planning to add support, maybe they can't due to 
NDA(s) with their USB-2-PCI-bridge provider.

I don't know for sure whether support can be added to the 
flexcop-usb.c-driver or not, but I assume not, because it is using a 
different USB-2-PCI-bridge and I have doubt that the USB high level 
interface is similar to the one used in flexcop-usb.

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
