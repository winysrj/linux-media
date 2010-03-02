Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40867 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0CBL0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Mar 2010 06:26:36 -0500
Received: by wya21 with SMTP id 21so67358wya.19
        for <linux-media@vger.kernel.org>; Tue, 02 Mar 2010 03:26:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100228205528.54d1ba69@tele>
References: <1267302028-7941-1-git-send-email-ospite@studenti.unina.it>
	<1267302028-7941-11-git-send-email-ospite@studenti.unina.it>
	<20100228194951.1c1e26ce@tele> <20100228201850.81f7904a.ospite@studenti.unina.it>
	<20100228205528.54d1ba69@tele>
From: "M.Ebrahimi" <m.ebrahimi@ieee.org>
Date: Tue, 2 Mar 2010 11:26:15 +0000
Message-ID: <1d742ad81003020326h5e02189bt6511b840dd17d7e3@mail.gmail.com>
Subject: Re: [PATCH 10/11] ov534: Add Powerline Frequency control
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org, Max Thrun <bear24rw@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28 February 2010 19:55, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Sun, 28 Feb 2010 20:18:50 +0100
> Antonio Ospite <ospite@studenti.unina.it> wrote:
>
>> Maybe we could just use
>>       V4L2_CID_POWER_LINE_FREQUENCY_DISABLED  = 0,
>>       V4L2_CID_POWER_LINE_FREQUENCY_50HZ      = 1,
>>
>> It looks like the code matches the DISABLED state (writing 0 to the
>> register). Mosalam?
>
> I don't know the ov772x sensor. I think it should look like the ov7670
> where there are 3 registers to control the light frequency: one
> register tells if light frequency filter must be used, and which
> frequency 50Hz or 60Hz; the two other ones give the filter values for
> each frequency.
>

I think it's safe to go with disabled/50hz. Perhaps later if needed
can patch it to control the filter values. Since it seems there is no
flickering in the 60hz regions at available frame rates, and this
register almost perfectly removes light flickers in the 50hz regions
(by modifying exposure/frame rate).

Mosalam
