Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:40053 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbeGMOx2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 10:53:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id z13-v6so9637704wma.5
        for <linux-media@vger.kernel.org>; Fri, 13 Jul 2018 07:38:32 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] media: rc: remove ir-rx51 in favour of generic
 pwm-ir-tx
To: Sean Young <sean@mess.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
Cc: linux-media@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
References: <20180713122230.19278-1-sean@mess.org>
 <20180713122230.19278-2-sean@mess.org>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <f44eb6ba-c94f-a397-1577-da647b880ac1@gmail.com>
Date: Fri, 13 Jul 2018 17:38:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180713122230.19278-2-sean@mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 13.07.2018 15:22, Sean Young wrote:
> The ir-rx51 is a pwm-based TX driver specific to the N900. This can be
> handled entirely by the generic pwm-ir-tx driver.
> 
> Note that the suspend code in the ir-rx51 driver is unnecessary, since
> during transmit, the process is not in interruptable sleep. The process
> is not put to sleep until the transmit completes.
> 
> Compile tested only.
> 

I would like to see this being tested on a real HW, however I am on a 
holiday for the next week so won't be able to test till I am back.

@Pali - do you have n900 with fremantle, upstream kernel and pierogi to 
test pwm-ir-tx on it?

Ivo
