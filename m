Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:33359 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZIMRbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 13:31:25 -0400
Received: by qw-out-2122.google.com with SMTP id 9so796473qwb.37
        for <linux-media@vger.kernel.org>; Sun, 13 Sep 2009 10:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251855051.3926.34.camel@palomino.walls.org>
References: <200909011019.35798.jarod@redhat.com>
	 <1251855051.3926.34.camel@palomino.walls.org>
Date: Sun, 13 Sep 2009 13:23:52 -0400
Message-ID: <de8cad4d0909131023t7103b446sf6b20889567556ee@mail.gmail.com>
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 1, 2009 at 9:30 PM, Andy Walls <awalls@radix.net> wrote:
> On Tue, 2009-09-01 at 10:19 -0400, Jarod Wilson wrote:
>> Patch is against http://hg.jannau.net/hdpvr/
>>
>> 1) Adds support for building hdpvr i2c support when i2c is built as a
>> module (based on work by David Engel on the mythtv-users list)
>>
>> 2) Refines the hdpvr_i2c_write() success check (based on a thread in
>> the sagetv forums)
>>
>> With this patch in place, and the latest lirc_zilog driver in my lirc
>> git tree, the IR part in my hdpvr works perfectly, both for reception
>> and transmitting.
>>
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>
> Jarod,
>
> I recall a problem Brandon Jenkins had from last year, that when I2C was
> enabled in hdpvr, his machine with multiple HVR-1600s and an HD-PVR
> would produce a kernel oops.
>
> Have you tested this on a machine with both an HVR-1600 and HD-PVR
> installed?
>
> Regards,
> Andy
>
>

I don't mind testing. Currently I am running ArchLinux 64-bit,
kernel26-2.6.30.6-1. Please tell me where to build the driver from.

Thanks,

Brandon
