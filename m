Return-path: <linux-media-owner@vger.kernel.org>
Received: from ffm.saftware.de ([83.141.3.46]:46280 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab1KVAWS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Nov 2011 19:22:18 -0500
Message-ID: <4ECAEB37.4040404@linuxtv.org>
Date: Tue, 22 Nov 2011 01:22:15 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: PATCH 00/13: Enumerate DVB frontend Delivery System capabilities
 to identify devices correctly.
References: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
In-Reply-To: <CAHFNz9KAi=XRZt=qM=KKnSKmmf_mn18JJAiUmd_5gXG71VBELA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.11.2011 22:05, Manu Abraham wrote:
> Hi,
> 
> As discussed prior, the following changes help to advertise a
> frontend's delivery system capabilities.
> 
> Sending out the patches as they are being worked out.
> 
> The following patch series are applied against media_tree.git
> after the following commit

Patches 7, 9 and 10 semm to be unneeded, because they just set the defaults.

Regarding the patches adding SYS_DSS: If I remember correctly, DSS
doesn't use MPEG-2 TS packets. Do we have a way to deliver DSS payload
to userspace?

Regards,
Andreas
