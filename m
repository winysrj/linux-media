Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:60986 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaDOSpE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 14:45:04 -0400
Message-ID: <534D7E24.4010602@sca-uk.com>
Date: Tue, 15 Apr 2014 19:44:52 +0100
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534D6241.5060903@sca-uk.com> <534D68C2.6050902@xs4all.nl>
In-Reply-To: <534D68C2.6050902@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 15/04/14 18:13, Hans Verkuil wrote:
> You may have to do a 'depmod -a' here. Try that first.
I tried that.  It worked fine.  No more error messages from

make -C .. rmmod

>> >11    tried to modprobe cx23885, but got "invalid agrgument"
> Somewhat strange error message. Does 'dmesg' give you any useful info?
However this error message is the same.  It actually:

ERROR: could not insert 'cx23885': Invalid argument
If I do a search for cx23885.ko, I find one that I have just created.  
If I cd to that directory and modprobe ./cx23885 I get no error messages.

However, lsmod | grep -i cx only finds cx2341x.

Dmesg continues to give:

[   13.237914] cx23885: disagrees about version of symbol altera_init
[   13.237917] cx23885: Unknown symbol altera_init (err -22)

altera_ci.ko is the only other file in 
/lib/modules/3.11.0-18-generic/kernel/drivers/media/pci/cx23885/*

Regards

Steve



