Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:51387 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbJSRk4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2015 13:40:56 -0400
Subject: Re: [PATCH 14/17] media: st-rc: remove misuse of IRQF_NO_SUSPEND flag
To: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1442850433-5903-1-git-send-email-sudeep.holla@arm.com>
 <1442850433-5903-15-git-send-email-sudeep.holla@arm.com>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"kernel@stlinux.com" <kernel@stlinux.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Sudeep Holla <sudeep.holla@arm.com>
Message-ID: <56252B24.4000207@arm.com>
Date: Mon, 19 Oct 2015 18:40:52 +0100
MIME-Version: 1.0
In-Reply-To: <1442850433-5903-15-git-send-email-sudeep.holla@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 21/09/15 16:47, Sudeep Holla wrote:
> The device is set as wakeup capable using proper wakeup API but the
> driver misuses IRQF_NO_SUSPEND to set the interrupt as wakeup source
> which is incorrect.
>
> This patch removes the use of IRQF_NO_SUSPEND flags replacing it with
> enable_irq_wake instead.
>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> Cc: Maxime Coquelin <maxime.coquelin@st.com>
> Cc: Patrice Chotard <patrice.chotard@st.com>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Can you pick couple of these media patches ?

-- 
Regards,
Sudeep
