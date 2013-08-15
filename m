Return-path: <linux-media-owner@vger.kernel.org>
Received: from service87.mimecast.com ([91.220.42.44]:46497 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3HONam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 09:30:42 -0400
Message-ID: <1376573438.18617.44.camel@hornet>
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
From: Pawel Moll <pawel.moll@arm.com>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
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
Date: Thu, 15 Aug 2013 14:30:38 +0100
In-Reply-To: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-08-14 at 18:27 +0100, Srinivas KANDAGATLA wrote:
> +Device-Tree bindings for ST IR and UHF receiver
> +
> +Required properties:
> +       - compatible: should be "st,rc".
> +       - st,uhfmode: boolean property to indicate if reception is in UHF.
> +       - reg: base physical address of the controller and length of memory
> +       mapped  region.
> +       - interrupts: interrupt number to the cpu. The interrupt specifier
> +       format depends on the interrupt controller parent.
> +
> +Example node:
> +
> +       rc: rc@fe518000 {
> +               compatible      = "st,rc";
> +               reg             = <0xfe518000 0x234>;
> +               interrupts      =  <0 203 0>;
> +       };

So is "st,uhfmode" required or optional after all? If the former, the
example is wrong (doesn't specify required property). But as far as I
understand it's really optional...

Paweł


