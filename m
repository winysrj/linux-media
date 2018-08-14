Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34828 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732209AbeHNNaZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 09:30:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id o18-v6so11786010wmc.0
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2018 03:43:48 -0700 (PDT)
Subject: Re: [BUG, RFC] media: Wrong module gets acquired
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
References: <d2bc538126492151ad325fa653924ca158a39b07.1534177949.git.petrcvekcz@gmail.com>
 <20180814083501.cml3fpxekbnyeois@paasikivi.fi.intel.com>
From: Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <a16568f2-30b6-37a2-1df7-a86bc5b462e5@gmail.com>
Date: Tue, 14 Aug 2018 12:44:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180814083501.cml3fpxekbnyeois@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 14.8.2018 v 10:35 Sakari Ailus napsal(a):
> Hi Pert,
> 

Hello,

thanks for answering

> On Mon, Aug 13, 2018 at 06:33:12PM +0200, petrcvekcz@gmail.com wrote:
>> From: Petr Cvek <petrcvekcz@gmail.com>
>>
>> When transferring a media sensor driver from the soc_camera I've found
>> the controller module can get removed (which will cause a stack dump
>> because the sensor driver depends on resources from the controller driver).
> 
> There may be a kernel oops if a resource used by another driver goes away.
> But the right fix isn't to prevent unloading that module. Instead, one way
> to address the problem would be to have persistent clock objects that would
> not be dependent on the driver that provides them.
> 

Yeah it is a hack, but it allows me to rmmod the sensor driver.
Otherwise it has a refcount "deadlock" as it holds the refcount on
itself. The _only_ way to unload the driver is to reboot.

ad clocks: Well the sensor driver and the controller are using
v4l2_clk_* so I was poking around that. Anyway the independent clock
object would be a problem, the clock control is inside the capture
driver register set (divider, enable) (I think) and it gets gated out
completely when the capture driver is unloaded. And when the clock is
stopped the sensor isn't responding to i2c commands. The clock control
is really dependent on the driver unless there is some callback to the
sensor which interrupts it from non-responding i2c transfers.

>>
>> When I've tried to remove the driver module of the sensor it said the
>> resource was busy (without a reference name) though is should be
>> possible to remove the sensor driver because it is at the end of
>> the dependency list and not to remove the controller driver.
> 
> That might be one day possible but it is not today.
> 
> You'll still need to acquire the sensor module as well as it registers a
> media entity as well as a sub-device.
> 

The ported sensor driver doesn't contain any media entity code.

best regards,
Petr
