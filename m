Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:39085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbZFNJtq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 05:49:46 -0400
Message-ID: <4A34C81A.1020306@redhat.com>
Date: Sun, 14 Jun 2009 11:51:22 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Erik de Castro Lopo <erik@bcode.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: GPL code for Omnivision USB video camera available.
References: <20090612110228.3f7e42ab.erik@bcode.com>	<4A31FB0A.8030104@redhat.com> <20090613104524.781027d8.erik@bcode.com>
In-Reply-To: <20090613104524.781027d8.erik@bcode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Erik,

For the latest version of the gspca ov519 driver, with all me
recent work for adding ov511 and ov518 support in it see:
http://linuxtv.org/hg/~hgoede/gspca


Regards,

Hans


On 06/13/2009 02:45 AM, Erik de Castro Lopo wrote:
> Hans de Goede wrote:
>
>> This looks to me like its just ov51x-jpeg made to compile with the
>> latest kernel.
>
> Its more than that. This driver supports a number of cameras and the
> only one we (bCODE) are really interested in is the ovfx2 driver.
>
>> Did you make any functional changes?
>
> I believe the ovfx2 driver is completely new.
>
>> Also I wonder if you're subscribed to the (low trafic) ov51x-jpeg
>> mailinglist, that seems to be the right thing todo for someone who tries
>> to get that driver in to the mainline.
>
> Sorry its the ovfx2 that I'm interested in pushing into  the kernel.
>
>> May I ask what cam you have? I could certainly use more people testing
>> this.
>
> It looks like this on the USB bus:
>
>      Bus 007 Device 002: ID 05a9:2800 OmniVision Technologies, Inc.
>
> Cheers,
> Erik
