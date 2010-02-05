Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19218 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0BEHnl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2010 02:43:41 -0500
Message-ID: <4B6BCC11.8030009@maxwell.research.nokia.com>
Date: Fri, 05 Feb 2010 09:43:13 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Trimarchi <michael@panicking.kicks-ass.org>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: omap34xxcam question?
References: <4B4F0762.4040007@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451538FFB@dlee02.ent.ti.com> <4B4F537B.7000708@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539065@dlee02.ent.ti.com> <4B4F56C8.7060108@panicking.kicks-ass.org> <A24693684029E5489D1D202277BE894451539623@dlee02.ent.ti.com> <4B502982.4050508@panicking.kicks-ass.org> <4B6AD7E3.6020102@maxwell.research.nokia.com> <4B6AE26D.4080701@panicking.kicks-ass.org>
In-Reply-To: <4B6AE26D.4080701@panicking.kicks-ass.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michael Trimarchi wrote:
> Hi,

Hi,

> Sakari Ailus wrote:
>> Hi Michael,
...
>> The frame sizes in our sensor drivers are in width descending order. The
>> selection has been working somehow so far but it's definitely not
>> perfect.
>>
> 
> Ok for the frame size but you need to test all the possible sensor output
> too and continue in case of error.

The try function should return an error only in real error cases, not
otherwise.

But as I said, this code will be removed soon from that driver...

>> We're converting the ISP driver to use the Media controller so this code
>> will be dropped in near future probably. In that case the user space has
>> to select the sensor mode it wants to use as well.
>>
> 
> Good.
> 
> Maybe I can test the framework on the FLOW1.5 mobile device using the
> TCM8240MD
> 
> What is your git for the camera framework?

It's all available here but I'm afraid you'll have to wait a bit first.
The legacy nodes (per sensor devices) are the only ones in existence at
the moment.

<URL:http://www.gitorious.org/projects/omap3camera>

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
