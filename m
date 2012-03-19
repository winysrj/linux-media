Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964874Ab2CSWuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:50:14 -0400
Message-ID: <4F67B80F.1040204@redhat.com>
Date: Mon, 19 Mar 2012 19:49:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Alex Gershgorin <alexg@meprolight.com>,
	linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
	fabio.estevam@freescale.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] i.MX35-PDK: Add Camera support
References: <1331651129-30540-1-git-send-email-alexg@meprolight.com> <4F67AD31.8030500@redhat.com> <4F67B077.5050300@redhat.com> <20120319223729.GC3852@pengutronix.de>
In-Reply-To: <20120319223729.GC3852@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-03-2012 19:37, Sascha Hauer escreveu:
> On Mon, Mar 19, 2012 at 07:17:27PM -0300, Mauro Carvalho Chehab wrote:
>> Em 19-03-2012 19:03, Mauro Carvalho Chehab escreveu:
>>> Em 13-03-2012 12:05, Alex Gershgorin escreveu:
>>>> In i.MX35-PDK, OV2640  camera is populated on the
>>>> personality board. This camera is registered as a subdevice via soc-camera interface.
>>>>
>>>> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
>>>
>>> Patch doesn't apply over v3.3:
>>
>> Sorry, the previous version of this patch didn't apply. This compiles OK.
>>
>> Sorry for the mess.
>>
>> Anyway, it should be applied via arm subtree.
> 
> It's scheduled there. I should have responded with an applied message.

Ok, thanks! 

Regards,
Mauro
