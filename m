Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4033 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947AbaDPJ61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 05:58:27 -0400
Message-ID: <534E5438.3030404@xs4all.nl>
Date: Wed, 16 Apr 2014 11:58:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson <it@sca-uk.com>, Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534D6241.5060903@sca-uk.com> <534D68C2.6050902@xs4all.nl> <534D7E24.4010602@sca-uk.com>
In-Reply-To: <534D7E24.4010602@sca-uk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/15/2014 08:44 PM, Steve Cookson wrote:
> Hi Hans,
> 
> On 15/04/14 18:13, Hans Verkuil wrote:
>> You may have to do a 'depmod -a' here. Try that first.
> I tried that.  It worked fine.  No more error messages from
> 
> make -C .. rmmod
> 
>>>> 11    tried to modprobe cx23885, but got "invalid agrgument"
>> Somewhat strange error message. Does 'dmesg' give you any useful info?
> However this error message is the same.  It actually:
> 
> ERROR: could not insert 'cx23885': Invalid argument
> If I do a search for cx23885.ko, I find one that I have just created.  
> If I cd to that directory and modprobe ./cx23885 I get no error messages.
> 
> However, lsmod | grep -i cx only finds cx2341x.
> 
> Dmesg continues to give:
> 
> [   13.237914] cx23885: disagrees about version of symbol altera_init
> [   13.237917] cx23885: Unknown symbol altera_init (err -22)
> 
> altera_ci.ko is the only other file in 
> /lib/modules/3.11.0-18-generic/kernel/drivers/media/pci/cx23885/*

Try this:

find /lib/modules/`uname -r`/|grep altera

If you have duplicate altera-stapl.ko files, then that might explain it.
In that case remove the older module.

It does install correctly for my 3.13 kernel.

Regards,

	Hans
