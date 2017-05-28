Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:44554 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750837AbdE1Rfi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 13:35:38 -0400
Received: from alans-desktop (82-70-14-226.dsl.in-addr.zen.co.uk [82.70.14.226])
        by fuzix.org (8.15.2/8.15.2) with ESMTP id v4SHZZVN017239
        for <linux-media@vger.kernel.org>; Sun, 28 May 2017 18:35:35 +0100
Date: Sun, 28 May 2017 18:35:35 +0100
From: Alan Cox <alan@llwyncelyn.cymru>
To: linux-media@vger.kernel.org
Subject: [2/7/] staging: atomisp: Do not call dev_warn with a NULL device
Message-ID: <20170528183535.21d49466@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>On Sun, May 28, 2017 at 3:31 PM, Hans de Goede <hdegoede@redhat.com>
wrote:
>> Do not call dev_warn with a NULL device, this silence the following 2
>> warnings:
>>
>> [   14.392194] (NULL device *): Failed to find gmin variable gmin_V2P8GPIO
>> [   14.392257] (NULL device *): Failed to find gmin variable gmin_V1P8GPIO
>>
>> We could switch to using pr_warn for dev == NULL instead, but as comments
>> in the source indicate, the check for these 2 special gmin variables with
>> a NULL device is a workaround for 2 specific evaluation boards, so
>> completely silencing the missing warning for these actually is a good
>> thing.
>
> Perhaps removing all code related explicitly to Gmin is a right thing to do.

That would make the driver somewhat useless because the Android derived
platforms I have seen that you can re-install Linux on that use this as
far as I am aware use the GMIN EFI variables.

Only the Windows platforms do it differently, and they appear to embed
the entire configuration in a machine specific driver for each platform
(at least the supposedly relevant ACPI in my T100TA appears to be copied
from an Intel reference board and bears no relation to the actual
hardware!)

Easy enough to check what a given Android x86 tablet does - plug it into a
powered OTG hub, add a live USB stick and a keyboard, hit the Fn key for
BIOS entry as it boots and boot off USB. You can then check lsacpi and
the EFI variables.

Alan
