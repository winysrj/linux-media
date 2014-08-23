Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47145 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaHWOFe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Aug 2014 10:05:34 -0400
Message-ID: <53F89FAC.4080708@iki.fi>
Date: Sat, 23 Aug 2014 17:05:32 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Bjoern <lkml@call-home.ch>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/5] Digital Devices PCIe bridge update to 0.9.15a
References: <1406951335-24026-1-git-send-email-crope@iki.fi> <1408794617.7936.2.camel@bjoern-W35xSTQ-370ST>
In-Reply-To: <1408794617.7936.2.camel@bjoern-W35xSTQ-370ST>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka
That patchset is simply far away from merge. Tons of issues to be fixed. 
It is huge amount of work to get that all in. I could estimate one month 
full time work even my experience is not enough. And I simply don't want 
to waste that much money from my pockets, it is many thousand euros. So 
I do it, if I do, on my schedule.

There is many separate issues which needs to be done. It is not 
something one people should do all. For example mainlining that 
DVB-T/T2/C/C2 demod driver. Another thing is DVB-C2 API, which is not 
much coding, but a lot of specification. You need to read and 
*understand* DVB-C2 spec and on some level other specs (mostly DVB-T2) 
in order to add missing pieces correctly to DVB API. If you are not 
coder, start here.


Antti



On 08/23/2014 02:50 PM, Bjoern wrote:
> Hi all,
>
> It's been 3 weeks since these patches were submitted - have they been
> merged yet? If not - what's the problem? Who has to check this?
>
> I'm not the only one longing for driver updated support of ddbridge "by
> default", and it would really be nice if there was some "progress" here.
> Antti did a lot of work here for all us ddbridge users.
>
> Regards,
> Bjoern
>
> On Sa, 2014-08-02 at 06:48 +0300, Antti Palosaari wrote:
>> After cold power-on, my device wasn't able to find DuoFlex C/C2/T/T2
>> Expansion card, which I added yesterday. I looked old and new drivers
>> and tried many things, but no success. Old kernel driver was ages,
>> many years, behind manufacturer current Linux driver and there has
>> been a tons of changes. So I ended up upgrading Linux kernel driver
>> to 0.9.15a (it was 0.5).
>>
>> Now it is very near Digital Devices official driver, only modulator
>> and network streaming stuff is removed and CI is abusing SEC like
>> earlier also.
>>
>> Few device models are not supported due to missing kernel driver or
>> missing device profile. Those devices are based of following DTV
>> frontend chipsets:
>> MaxLinear MxL5xx
>> STMicroelectronics STV0910
>> STMicroelectronics STV0367
>>
>>
>> Tree for testing is here:
>> http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=digitaldevices
>>
>> regards
>> Antti
>>
>>
>> Antti Palosaari (5):
>>    cxd2843: do not call get_if_frequency() when it is NULL
>>    ddbridge: disable driver building
>>    ddbridge: remove driver temporarily
>>    ddbridge: add needed files from manufacturer driver 0.9.15a
>>    ddbridge: clean up driver for release
>>
>>   drivers/media/dvb-frontends/cxd2843.c      |    3 +-
>>   drivers/media/pci/ddbridge/Makefile        |    2 -
>>   drivers/media/pci/ddbridge/ddbridge-core.c | 3175 +++++++++++++++++++---------
>>   drivers/media/pci/ddbridge/ddbridge-i2c.c  |  232 ++
>>   drivers/media/pci/ddbridge/ddbridge-regs.h |  347 ++-
>>   drivers/media/pci/ddbridge/ddbridge.c      |  456 ++++
>>   drivers/media/pci/ddbridge/ddbridge.h      |  407 +++-
>>   7 files changed, 3518 insertions(+), 1104 deletions(-)
>>   create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c
>>   create mode 100644 drivers/media/pci/ddbridge/ddbridge.c
>>
>
>

-- 
http://palosaari.fi/
