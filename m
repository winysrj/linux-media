Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809Ab2B1K3C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 05:29:02 -0500
Message-ID: <4F4CAC5E.7050703@redhat.com>
Date: Tue, 28 Feb 2012 07:28:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: Re: [PATCH v4 0/2] Add support form eMMa-PrP in i.MX2 chips as a
 mem2mem device.
References: <1323690225-15799-1-git-send-email-javier.martin@vista-silicon.com> <CACKLOr1RujFbuTnF=DkCTB=paVUq7=j1Ru_RU7DWyuJedM+Cvg@mail.gmail.com> <4F021DCE.8000105@gmail.com> <CACKLOr0YczU+jGOuKoRNvOUYhMbc3x_LVk3Gnt-dq+KfppwzFA@mail.gmail.com> <4F02D009.8080009@samsung.com>
In-Reply-To: <4F02D009.8080009@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-01-2012 07:53, Sylwester Nawrocki escreveu:
> On 01/03/2012 08:43 AM, javier Martin wrote:
>> Do you mean I have to set up a public GIT repository? Is this mandatory?
>> I am not a subsystem maintainer, just casual developer.
> 
> It's not mandatory. But it helps Mauro to distinguish between RFC and patches
> for merging AFAIK. I think you can ask him to pickup patches from the mailing
> list directly.
> 
>> What about this?
>>
>> http://linuxtv.org/wiki/index.php/Maintaining_Git_trees#Patches_submitted_via_email

We have a high patch traffic at the ML. While all patches are stored there, I
generally wait for a while, for the driver maintainers to catch their patches.

Also, those SoC patches in general generate lots of discussions and versions
(it is not unusual to have about 20 versions of big patch series, where most
of the changes are driver-specific logic, where I can't contribute, as I lack
resources to analyze those small implementation-specific details).
 
So, what I generally do with SoC drivers is to mark them all as RFC at
patchwork, and I wait for the SoC maintainer to send me a pull request.

Anyway, as you've send me a git pull request, and the driver looks ok, I'm
applying it on my tree.

Regards,
Mauro
