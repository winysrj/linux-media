Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32993 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752882AbdLST0b (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 14:26:31 -0500
Reply-To: minyard@acm.org
Subject: Re: [-next PATCH 0/4] sysfs and DEVICE_ATTR_<foo>
To: Joe Perches <joe@perches.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        platform-driver-x86@vger.kernel.org, linux-s390@vger.kernel.org,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org
Cc: linux-sh@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
References: <cover.1513706701.git.joe@perches.com>
From: Corey Minyard <minyard@acm.org>
Message-ID: <09832872-8e6c-3327-6e28-7ee6cc48df04@acm.org>
Date: Tue, 19 Dec 2017 13:26:26 -0600
MIME-Version: 1.0
In-Reply-To: <cover.1513706701.git.joe@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/19/2017 12:15 PM, Joe Perches wrote:
>   drivers/char/ipmi/ipmi_msghandler.c                | 17 +++---

For ipmi:

Acked-by: Corey Minyard <cminyard@mvista.com>
