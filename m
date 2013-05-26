Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab3EZKyL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 06:54:11 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4QAsBE7007159
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 26 May 2013 06:54:11 -0400
Received: from localhost.localdomain (vpn1-6-205.ams2.redhat.com [10.36.6.205])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r4QAs9A3024839
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 26 May 2013 06:54:10 -0400
Message-ID: <51A1EB10.7030606@redhat.com>
Date: Sun, 26 May 2013 12:59:28 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: InstantFM
References: <51993390.6080202@theo.to> <5199C8FA.9060704@redhat.com> <519A4464.7060006@theo.to> <519A6DBB.60608@theo.to> <519B23A7.90504@redhat.com> <519B649C.9040903@theo.to> <519C7E8B.9090406@redhat.com> <20130522140525.GF4308@ptaff.ca> <519DD31D.5080802@redhat.com> <20130525171852.GV4308@ptaff.ca>
In-Reply-To: <20130525171852.GV4308@ptaff.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/25/2013 07:18 PM, Patrice Levesque wrote:
>
>> This, as well as the "Invalid freq '127150000'" and the "get_baseline:
>> min=65535.000000 max=65535.000000" messages seem to indicate that only
>> FFFF is being read from all the registers of the tuner chip, so
>> somehow the communication between the usb micro-controller and the
>> si470x tuner chip is not working.
>
> A disconnect-connect of the USB device reset its internal state and now
> I can confirm the device properly works with the 3.9.3-gentoo kernel,
> using the 3.103 version of xawtv.
>
> Under the same kernel, the 3.95-r2 xawtv version shipped with gentoo
> fails to detect signal: “radio -i -d” outputs no channel and shows
> “get_baseline: min=0.000000 max=0.000000”.
>
>
> Thanks for your good work on this, you know who you are,

Good to hear, your device has "software version 0, hardware version 7",
right? If you can confirm then I'll lower the version requirement in
the kernel too match (so that you'll no longer get the warning message).

Regards,

Hans
