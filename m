Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36197 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbcEYQY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2016 12:24:56 -0400
Message-ID: <57459280.8060007@gmail.com>
Date: Wed, 25 May 2016 17:24:40 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 5/5] staging: media: lirc: use new parport device model
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>	<1450443929-15305-5-git-send-email-sudipm.mukherjee@gmail.com>	<20160125142906.184a4cb5@recife.lan>	<20160125170230.GA8787@sudip-laptop> <20160125151257.24d5c7d2@recife.lan>
In-Reply-To: <20160125151257.24d5c7d2@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 25 January 2016 10:42 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 25 Jan 2016 22:32:31 +0530
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> escreveu:
>
>> On Mon, Jan 25, 2016 at 02:29:06PM -0200, Mauro Carvalho Chehab wrote:
>>> Em Fri, 18 Dec 2015 18:35:29 +0530
>>> Sudip Mukherjee <sudipm.mukherjee@gmail.com> escreveu:
>>>
>>>> Modify lirc_parallel driver to use the new parallel port device model.
>>>
>>> Did you or someone else tested this patch?
>>
>> Only build tested and tested by inserting and removing the module.
>> But since the only change is in the way it registers and nothing else
>> so it should not break.
>
> It would be worth to wait for a while in the hope that someone could
> test with a real hardware.

Hi Mauro,
Since no one has commented on the patch till now, maybe you can merge 
now, or do i need to resend?

Regards
Sudip
