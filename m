Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:37191
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbZIMVEZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 17:04:25 -0400
Cc: Andy Walls <awalls@radix.net>, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>, linux-media@vger.kernel.org
Message-Id: <6EBCDFA3-FAAA-4757-97B6-9CF3442FE920@wilsonet.com>
From: Jarod Wilson <jarod@wilsonet.com>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
In-Reply-To: <de8cad4d0909131023t7103b446sf6b20889567556ee@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: [PATCH] hdpvr: i2c fixups for fully functional IR support
Date: Sun, 13 Sep 2009 17:04:16 -0400
References: <200909011019.35798.jarod@redhat.com> <1251855051.3926.34.camel@palomino.walls.org> <de8cad4d0909131023t7103b446sf6b20889567556ee@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sep 13, 2009, at 1:23 PM, Brandon Jenkins wrote:

> On Tue, Sep 1, 2009 at 9:30 PM, Andy Walls <awalls@radix.net> wrote:
>> On Tue, 2009-09-01 at 10:19 -0400, Jarod Wilson wrote:
>>> Patch is against http://hg.jannau.net/hdpvr/
>>>
>>> 1) Adds support for building hdpvr i2c support when i2c is built  
>>> as a
>>> module (based on work by David Engel on the mythtv-users list)
>>>
>>> 2) Refines the hdpvr_i2c_write() success check (based on a thread in
>>> the sagetv forums)
>>>
>>> With this patch in place, and the latest lirc_zilog driver in my  
>>> lirc
>>> git tree, the IR part in my hdpvr works perfectly, both for  
>>> reception
>>> and transmitting.
>>>
>>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>>
>> Jarod,
>>
>> I recall a problem Brandon Jenkins had from last year, that when  
>> I2C was
>> enabled in hdpvr, his machine with multiple HVR-1600s and an HD-PVR
>> would produce a kernel oops.
>>
>> Have you tested this on a machine with both an HVR-1600 and HD-PVR
>> installed?
>>
>> Regards,
>> Andy
>>
>>
>
> I don't mind testing. Currently I am running ArchLinux 64-bit,
> kernel26-2.6.30.6-1. Please tell me where to build the driver from.


Hrm... It *was* in Janne's hdpvr tree, but it seems to have gone  
missing... v4l-dvb tip + this patch should work too:

http://wilsonet.com/jarod/junk/hdpvr-ir/hdpvr-ir-2.6.31.patch

This is exactly what I put in the Fedora 2.6.31 kernel, iirc, and  
works a treat here. Have also tested against 2.6.29 in a box with a  
pcHDTV HD-3000 a Hauppauge HVR-1250 and HVR-1800 in it with no issues,  
so fingers crossed...

-- 
Jarod Wilson
jarod@wilsonet.com




