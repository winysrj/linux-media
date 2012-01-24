Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64607 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab2AXROL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 12:14:11 -0500
Received: by wgbed3 with SMTP id ed3so4265699wgb.1
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 09:14:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1EC725.7090204@iki.fi>
References: <44895934A66CD441A02DCF15DD759BA0011CAE69@SYDEXCHTMP2.au.fjanz.com>
	<4F1E9A78.7020203@iki.fi>
	<CAGoCfizF=aO-JTLLCAK=QgsPSVP13SzbB9j6wCFfVzGXc4hnfw@mail.gmail.com>
	<4F1EC725.7090204@iki.fi>
Date: Tue, 24 Jan 2012 22:44:10 +0530
Message-ID: <CAHFNz9K7g_M1+k9pjv2MmF0Xfti-_Nqi-93+bqBQ20Aw+PfLiQ@mail.gmail.com>
Subject: Re: HVR 4000 hybrid card still producing multiple frontends for
 single adapter
From: Manu Abraham <abraham.manu@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	"Hawes, Mark" <MARK.HAWES@au.fujitsu.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 24, 2012 at 8:28 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 01/24/2012 04:49 PM, Devin Heitmueller wrote:
>>
>> On Tue, Jan 24, 2012 at 6:48 AM, Antti Palosaari<crope@iki.fi>  wrote:
>>>
>>> On 01/24/2012 06:41 AM, Hawes, Mark wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>> I have a HVR 4000 hybrid card  which provides both DVB-S2 and DVB-T
>>>> capabilities on the one adapter. Using the current media tree build
>>>> updated
>>>> with the contents of the linux media drivers tarball dated 22/01/2012
>>>> the
>>>> drivers for this card are still generating two frontends on the adapter
>>>> as
>>>> below:
>>>>
>>>>> Jan 23 12:16:44 Nutrigrain kernel: [    9.346240] DVB: registering
>>>>> adapter 1 frontend 0 (Conexant CX24116/CX24118)...
>>>>> Jan 23 12:16:44 Nutrigrain kernel: [    9.349110] DVB: registering
>>>>> adapter 1 frontend 1 (Conexant CX22702 DVB-T)...
>>>>
>>>>
>>>>
>>>> I understand that this behaviour is now deprecated and that the correct
>>>> behaviour should be to generate one front end with multiple
>>>> capabilities.
>>>> Can this please be corrected.
>>>
>>>
>>>
>>> Same applies for many other devices too. For example some older Anysee E7
>>> models have two chip and two frontends whilst new one have only one. Also
>>> TechnoTrend CT3650 and Hauppauge WinTV.
>>>
>>> Maybe it those are implemented later as one frontend, it not clear for
>>> me.
>>
>>
>> The merging of frontends is something that is only done if there are
>> multiple modulation types on the same demodulator chip.  As the
>> HVR-4000 has separate demods for DVB-T versus DVB-S2, they will always
>> be represented by two separate frontends (for the foreseeable future).
>>
>> In other words, the recent work doesn't apply to this card (and others
>> like it).
>
>
> So what was the actual benefit then just introduce one way more to implement
> same thing. As I sometime understood from Manu's talk there will not be
> difference if my device is based of DVB-T + DVB-C demod combination or just
> single chip that does same. Now there is devices that have same
> characteristics but different interface.

Yes, you are right. I had a very preliminary patch to handle this,
Will post it soon.

Regards,
Manu
