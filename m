Return-path: <linux-media-owner@vger.kernel.org>
Received: from iris.cdu.edu.au ([138.80.130.6]:34602 "HELO iris.cdu.edu.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751713AbZH2NvX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 09:51:23 -0400
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net> <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de> <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net> <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de> <1251042115.19935.16.camel@lychee.local> <4A9296D5.1070202@nildram.co.uk> <A971DB9B-7353-4BD1-AFF3-6B30239533DF@cdu.edu.au> <1251129649.5234.42.camel@acropora>
Message-ID: <64BF8339-B3B1-4EDA-858A-42841A5D9722@cdu.edu.au>
From: "Malcolm Caldwell" <Malcolm.Caldwell@cdu.edu.au>
To: "Nicolas Will" <nico@youplala.net>
In-Reply-To: <1251129649.5234.42.camel@acropora>
Content-Type: text/plain;
	format=flowed;
	delsp=yes;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0 (iPhone Mail 7A341)
Subject: Re: Nova-TD-500 (84xxx) problems (was Re: dib0700 diversity support)
Date: Sat, 29 Aug 2009 23:20:31 +0930
Cc: <linux-media@vger.kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/08/2009, at 1:31, "Nicolas Will" <nico@youplala.net> wrote:

> On Tue, 2009-08-25 at 00:36 +0930, Malcolm Caldwell wrote:
>>> Have you tried adding:
>>>
>>> dvb_usb_dib0700.force_lna_activation=1
>>>
>>> to the modprobe options?
>>>
>>> The device I had wouldn't tune without this.
>>
>> I should have mentioned that I have tried this and buggy sfn
>> workaround for the relavent modules.
>
> I have read that sometimes the problem is not a low signal, but too
> strong a signal.
>
> Have you tried placing an attenuator in front of the card?

Ok, I have now tried an attenuator and it did not fix my problem, but  
made the reception worse.


>
> Nico
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
