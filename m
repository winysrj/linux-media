Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:39390 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbZCZH7h (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 03:59:37 -0400
Message-ID: <49CB3606.6030909@windriver.com>
Date: Thu, 26 Mar 2009 16:00:06 +0800
From: "stanley.miao" <stanley.miao@windriver.com>
MIME-Version: 1.0
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"Tuukka.O Toivonen" <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
	"DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	MiaoStanley <stanleymiao@hotmail.com>,
	"Nagalla, Hari" <hnagalla@ti.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>,
	"Lakhani, Amish" <amish@ti.com>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [PATCH 5/5] LDP: Add support for built-in camera
References: <A24693684029E5489D1D202277BE89442E53A3CC@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89442E53A3CC@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre Rodriguez, Sergio Alberto wrote:
>   
>> -----Original Message-----
>> From: stanley.miao [mailto:stanley.miao@windriver.com]
>> Sent: Tuesday, March 10, 2009 3:04 AM
>> To: Aguirre Rodriguez, Sergio Alberto
>> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Sakari Ailus;
>> Tuukka.O Toivonen; Hiroshi DOYU; DongSoo(Nathaniel) Kim; MiaoStanley;
>> Nagalla, Hari; Hiremath, Vaibhav; Lakhani, Amish; Menon, Nishanth
>> Subject: RE: [PATCH 5/5] LDP: Add support for built-in camera
>>
>> On Mon, 2009-03-09 at 15:24 -0500, Aguirre Rodriguez, Sergio Alberto
>> wrote:
>>     
>> <snip>
>> out
>>     
>>>> when I run my test program.
>>>>
>>>> <3>CSI2: ComplexIO Error IRQ 80
>>>> CSI2: ComplexIO Error IRQ 80
>>>> <3>CSI2: ComplexIO Error IRQ c2
>>>> CSI2: ComplexIO Error IRQ c2
>>>> <3>CSI2: ComplexIO Error IRQ c2
>>>> CSI2: ComplexIO Error IRQ c2
>>>> <3>CSI2: ComplexIO Error IRQ c6
>>>> CSI2: ComplexIO Error IRQ c6
>>>> <3>CSI2: ECC correction failed
>>>> CSI2: ECC correction failed
>>>> <3>CSI2: ComplexIO Error IRQ 6
>>>> CSI2: ComplexIO Error IRQ 6
>>>> <3>CSI2: ComplexIO Error IRQ 6
>>>> CSI2: ComplexIO Error IRQ 6
>>>> <3>CSI2: ComplexIO Error IRQ 6
>>>> CSI2: ComplexIO Error IRQ 6
>>>> <3>CSI2: ComplexIO Error IRQ 6
>>>> CSI2: ComplexIO Error IRQ 6
>>>>
>>>>         
>>> Oops, my mistake. Missed to add that struct there... Fixed now.
>>>
>>> About the CSI2 errors you're receiving... Which version of LDP are you
>>>       
>> using? Which Silicon revision has (ES2.1 or ES3.0)?
>>
>> ZOOM1 board(LDP3430-VG1.0.0-1), omap3430 ES2.1.
>>
>> When I use your old version patch, sometimes the test succeed, sometimes
>> failed(no data was generated and no error). This version, always failed.
>>     
>
> Stanley,
>
> I'm working on some CSI2 fixes that could help you with this..
>
> I'll keep you updated on this.
>
> Also, about your board version, it is possible that you'll need a HW modfix because of a redundant resistor in CSI2 datalanes. I'm in talks with some people at TI to prepare a ready to publish document about this rework.
>
> Zoom1 with ES3 silicon doesn't need this HW fix.
>   
Hi, Sergio,

When I used your version in omapzoom tree, the camera worked sometimes. 
So I think it's not HW's problem.

My test program is capture.c that I got from v4l2 spec and did some 
modifications.
This is my test log:

root@localhost:/root> ./capture -d /dev/video4
select timeout
read_frame: Resource temporarily unavailable
select timeout
read_frame: Resource temporarily unavailable
^C

root@localhost:/root> ./capture -d /dev/video4
Got 20 frames data, success.

root@localhost:/root> ./capture -d /dev/video4
CSI2: ECC correction failed
CSI2: Short packet receive error
CSI2: ECC correction failed
CSI2: Short packet receive error
CSI2: ECC correction failed
CSI2: Short packet receive error
CSI2: ECC correction failed
CSI2: Short packet receive error
CSI2: ECC correction failed
CSI2: Short packet receive error
CSI2: ECC correction failed
CSI2: Short packet receive error
CSI2: ECC correction failed
select timeout
read_frame: Resource temporarily unavailable
select timeout
read_frame: Resource temporarily unavailable
select timeout
read_frame: Resource temporarily unavailable
select timeout
read_frame: Resource temporarily unavailable
^C

"select timeout" means that no data was generated.

Stanley.

> I'll hope to get back to you about this next week.
>
> Regards,
> Sergio
>
>   
>> Thanks.
>> Stanley.
>>
>>     
>>> Regards,
>>> Sergio
>>>       
>>>> Stanley.
>>>>         
>
>
>   

