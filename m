Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34566 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729311AbeHOQdx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:33:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id c13-v6so1182365wrt.1
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2018 06:41:39 -0700 (PDT)
Subject: Re: [BUG, RFC] media: Wrong module gets acquired
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org
References: <d2bc538126492151ad325fa653924ca158a39b07.1534177949.git.petrcvekcz@gmail.com>
 <20180814083501.cml3fpxekbnyeois@paasikivi.fi.intel.com>
 <20180814100312.096672fb@coco.lan>
From: Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <cd25a0e4-ba9d-178d-2dec-096aa81117d3@gmail.com>
Date: Wed, 15 Aug 2018 15:42:34 +0200
MIME-Version: 1.0
In-Reply-To: <20180814100312.096672fb@coco.lan>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: cs
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Dne 14.8.2018 v 15:03 Mauro Carvalho Chehab napsal(a):
> Em Tue, 14 Aug 2018 11:35:01 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> Hi Pert,
>>
>> On Mon, Aug 13, 2018 at 06:33:12PM +0200, petrcvekcz@gmail.com wrote:
>>> From: Petr Cvek <petrcvekcz@gmail.com>
>>>
>>> When transferring a media sensor driver from the soc_camera I've found
>>> the controller module can get removed (which will cause a stack dump
>>> because the sensor driver depends on resources from the controller driver).  
>>
>> There may be a kernel oops if a resource used by another driver goes away.
>> But the right fix isn't to prevent unloading that module. Instead, one way
>> to address the problem would be to have persistent clock objects that would
>> not be dependent on the driver that provides them.
>>
>>>
>>> When I've tried to remove the driver module of the sensor it said the
>>> resource was busy (without a reference name) though is should be
>>> possible to remove the sensor driver because it is at the end of
>>> the dependency list and not to remove the controller driver.  
>>
>> That might be one day possible but it is not today.
>>
>> You'll still need to acquire the sensor module as well as it registers a
>> media entity as well as a sub-device.
> 
> Let put my 2 cents here.
> 
> Usually, the same problem of removing modules happen if you just
> ask the driver's core to unbind a module (with can be done via
> sysfs).
> 
> Removing/unbinding a driver that uses media controller should work,
> if the unbinding code at the driver (e. g. i2c_driver::remove field)
> would delete the media controller entities, and the caller driver
> doesn't cache it.
> 

Yeah I assume it would be same as removing my sensor module from
v4l2_async and unregistering v4l2 clocks.

Petr
