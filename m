Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36308 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756520Ab3HONhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 09:37:37 -0400
Message-ID: <520CD640.5030900@st.com>
Date: Thu, 15 Aug 2013 14:23:12 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Rob Landley <rob@landley.net>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com> <1376573438.18617.44.camel@hornet>
In-Reply-To: <1376573438.18617.44.camel@hornet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/08/13 14:30, Pawel Moll wrote:
> On Wed, 2013-08-14 at 18:27 +0100, Srinivas KANDAGATLA wrote:
>> +Device-Tree bindings for ST IR and UHF receiver
>> +
>> +Required properties:
>> +       - compatible: should be "st,rc".
>> +       - st,uhfmode: boolean property to indicate if reception is in UHF.
>> +       - reg: base physical address of the controller and length of memory
>> +       mapped  region.
>> +       - interrupts: interrupt number to the cpu. The interrupt specifier
>> +       format depends on the interrupt controller parent.
>> +
>> +Example node:
>> +
>> +       rc: rc@fe518000 {
>> +               compatible      = "st,rc";
>> +               reg             = <0xfe518000 0x234>;
>> +               interrupts      =  <0 203 0>;
>> +       };
> 
> So is "st,uhfmode" required or optional after all? If the former, the
> example is wrong (doesn't specify required property). But as far as I
> understand it's really optional...


You are right, I will move this to optional properties section.

Thanks,
srini
> 
> Paweł
> 
> 
> 

