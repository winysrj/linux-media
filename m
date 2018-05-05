Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:38329 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750821AbeEEMdr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 08:33:47 -0400
Subject: Re: compile error media-build on 4.15 because of
 'device_get_match_data'
To: Martin Dauskardt <martin.dauskardt@gmx.de>,
        linux-media <linux-media@vger.kernel.org>
References: <058eb808-5072-d9fb-c83c-5bc1201568fc@gmx.de>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <4abfcdf2-cb54-a9c9-fafd-354b26c5f078@anw.at>
Date: Sat, 5 May 2018 14:33:45 +0200
MIME-Version: 1.0
In-Reply-To: <058eb808-5072-d9fb-c83c-5bc1201568fc@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

I just pushed a fix to media-build.
But I had to disable the driver for Kernels older than 4.16.
-> VIDEO_I2C requires device_get_match_data which requires
   the function pointer device_get_match_data in fwnode_operations.
The latter has been added first in Kernel 4.16.

If someone wants to have VIDEO_I2C in Kernels older than 4.16,
please provide patch.

BR,
   Jasmin
