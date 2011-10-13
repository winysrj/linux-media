Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65247 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1JMXTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Oct 2011 19:19:03 -0400
Received: by bkbzt4 with SMTP id zt4so2073461bkb.19
        for <linux-media@vger.kernel.org>; Thu, 13 Oct 2011 16:19:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E976EF6.1030101@southpole.se>
References: <CAGa-wNOL_1ua0DQFRPFuLtHO0zTFhE0DaM+b6kujMEEL4dQbKg@mail.gmail.com>
	<CAGoCfizwYRpSsqobaHWJd5d0wq1N0KSXEQ1Un_ue01KuYGHaWA@mail.gmail.com>
	<4E970CA7.8020807@iki.fi>
	<CAGoCfiwSJ7EGXxAw7UgbFeECh+dg1EueXEC9iCHu7TaXia=-mQ@mail.gmail.com>
	<4E970F7A.5010304@iki.fi>
	<CAGoCfiyXiANjoB5bXgBpjwOAk8kpz8guxTGuGtVbtgc6+DNAag@mail.gmail.com>
	<4E976EF6.1030101@southpole.se>
Date: Thu, 13 Oct 2011 19:19:01 -0400
Message-ID: <CAGoCfixwp-iVFJysEG=UjN63-U_P4mdFWt+8hCwFW7fYeADvuw@mail.gmail.com>
Subject: Re: PCTV 520e on Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Benjamin Larsson <benjamin@southpole.se>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 7:06 PM, Benjamin Larsson <benjamin@southpole.se> wrote:
> On 10/13/2011 07:48 PM, Devin Heitmueller wrote:
>> On Thu, Oct 13, 2011 at 12:19 PM, Antti Palosaari <crope@iki.fi> wrote:
>>>> You were close:  em2884, drx-k, xc5000, and for analog it uses the
>>>> afv4910b.
>>> Then it should be peace of cake at least for digital side.
>> I don't think we've ever done xc5000 on an em28xx before, so it's
>> entirely possible that the xc5000 clock stretching will expose bugs in
>> the em28xx i2c implementation (it uncovered bugs in essentially every
>> other bridge driver I did work on).
>>
>> That, and we don't know how much is hard-coded into the drx-k driver
>> making it specific to the couple of device it's currently being used
>> with.
>>
>> But yeah, it shouldn't be rocket science.  I added support for the
>> board in my OSX driver and it only took me a couple of hours.
>>
>> Devin
>>
>
> Eddi De Pieri has patches for the HVR-930C that works somewhat. The
> hardware in that stick is the same.
>
> MvH
> Benjamin Larsson

While the basic chips used are different, they are completely
different hardware designs and likely have different GPIO
configurations as well as IF specs.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
