Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42477 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801AbZLJT6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 14:58:24 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Thu, 10 Dec 2009 13:58:28 -0600
Subject: RE: [PATCH - v1 1/2] V4L - vpfe capture - make clocks configurable
Message-ID: <A69FA2915331DC488A831521EAE36FE40155C80BF0@dlee06.ent.ti.com>
References: <1259687940-31435-1-git-send-email-m-karicheri2@ti.com>
	<87hbs0xhlx.fsf@deeprootsystems.com>
	<A69FA2915331DC488A831521EAE36FE40155C805C3@dlee06.ent.ti.com>
 <877hsur6tv.fsf@deeprootsystems.com>
In-Reply-To: <877hsur6tv.fsf@deeprootsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


>> I thought following is correct:-
>> Probe()
>> clk_get() followed by clk_enable()
>> Remove()
>> clk_disable() followed by clk_put()
>> Suspend()
>> clk_disable()
>> Resume()
>> clk_enable()
>
>Yes, that is correct.
>
>I didn't look at the whole driver.  My concern was that if the driver
>was enhanced to more aggressive clock management, you shouldn't do a
>clk_get() every time you do a clk_enable(), same for put.
Got you. I am in sync with your thinking.
-Murali
>
>Kevin
