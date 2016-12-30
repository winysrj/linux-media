Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:33899 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751961AbcL3LaE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Dec 2016 06:30:04 -0500
Subject: Re: [PATCH 1/5] [media] ir-rx51: port to rc-core
To: Sean Young <sean@mess.org>
References: <cover.1482255894.git.sean@mess.org>
 <f5262cc638a494f238ef96a80d8f45265ca2fd02.1482255894.git.sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>,
        Pavel Machek <pavel@ucw.cz>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5878d916-6a60-d5c3-b912-948b5b970661@gmail.com>
Date: Fri, 30 Dec 2016 13:30:01 +0200
MIME-Version: 1.0
In-Reply-To: <f5262cc638a494f238ef96a80d8f45265ca2fd02.1482255894.git.sean@mess.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 20.12.2016 19:50, Sean Young wrote:
> This driver was written using lirc since rc-core did not support
> transmitter-only hardware at that time. Now that it does, port
> this driver.
>
> Compile tested only.
>

I guess after that change, there will be no more /dev/lircN device, 
right? Neither will LIRC_XXX IOCTL codes be supported?

That looks to me as a completely new driver, not a port to new API.

Right now there are applications using the current behaviour (pierogi 
for example), which will be broken by the change.

Ivo
