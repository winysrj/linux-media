Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:40987 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753259Ab0BSW4T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 17:56:19 -0500
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Fri, 19 Feb 2010 14:56:17 -0800
Message-ID: <4B7F1711.6030303@xenotime.net>
Date: Fri, 19 Feb 2010 14:56:17 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	sameo@linux.intel.com
Subject: Re: [PATCH] mfd: Add timb-radio to the timberdale MFD
References: <4B7845F0.1070800@pelagicore.com> <4B7E7B75.3040205@redhat.com> <4B7F13B2.50804@pelagicore.com>
In-Reply-To: <4B7F13B2.50804@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/10 14:41, Richard Röjfors wrote:
> On 02/19/2010 04:52 AM, Mauro Carvalho Chehab wrote:
>> Richard Röjfors wrote:
>>> This patch addes timb-radio to all configurations of the timberdale MFD.
>>>
>>> Connected to the FPGA is a TEF6862 tuner and a SAA7706H DSP, the I2C
>>> board info of these devices is passed via the timb-radio platform data.
>>
>> Hi Richard,
>>
>> I'm trying to apply it to my git tree
>> (http://git.linuxtv.org/v4l-dvb.git),
>> but it is failing:
> 
> Hi Mauro,
> 
> Right now my mail client, icedove, confuses me. Just upgraded to ver 3.
> It seem to add in an extra space to lines not starting with a plus in
> the patch.

I had that problem with something called Thunderbird.  Perhaps you could
use the hints in Documentation/email-clients.txt but change Thunderbird
to icedove.  (?)


> I attached the patch.
> 
> Sorry for the inconvenience.
> 
> --Richard


-- 
~Randy
