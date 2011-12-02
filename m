Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:39203 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970Ab1LBXSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 18:18:42 -0500
From: Kevin Hilman <khilman@ti.com>
To: "Aguirre\, Sergio" <saaguirre@ti.com>
Cc: "Hiremath\, Vaibhav" <hvaibhav@ti.com>,
	"linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"laurent.pinchart\@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"sakari.ailus\@iki.fi" <sakari.ailus@iki.fi>,
	Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH v2 04/11] OMAP4: hwmod: Include CSI2A and CSIPHY1 memory sections
References: <1322698500-29924-1-git-send-email-saaguirre@ti.com>
	<1322698500-29924-5-git-send-email-saaguirre@ti.com>
	<79CD15C6BA57404B839C016229A409A8046FCD@DBDE01.ent.ti.com>
	<CAKnK67TrzD1hoKOOaodRK=-Ct5bNYAtXab3hY4UdxJTNdD0Tuw@mail.gmail.com>
	<87pqg6lhcp.fsf@ti.com>
	<CAKnK67RVgSsNP-BGfkkWZ8wv5MsSL7H9+Joby3LrXihfO6tpAA@mail.gmail.com>
Date: Fri, 02 Dec 2011 15:18:37 -0800
In-Reply-To: <CAKnK67RVgSsNP-BGfkkWZ8wv5MsSL7H9+Joby3LrXihfO6tpAA@mail.gmail.com>
	(Sergio Aguirre's message of "Fri, 2 Dec 2011 16:59:36 -0600")
Message-ID: <87aa7alfzm.fsf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"Aguirre, Sergio" <saaguirre@ti.com> writes:

[...]

>>
>> Also, work with Benoit to make sure at the scripts that autogenerate
>> this data are updated to include these two regions.
>
> Ok.
>
> As a side note, I might need more addresses for the rest of the ISP
> components later on. I'll enable more subsystems once the CSI2-A only
> initial version is in an acceptable state.

That's fine, just work with Benoit to be sure that the autogen scripts
are updated for all the subsystems.

Kevin
