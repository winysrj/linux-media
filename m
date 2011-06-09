Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab1FINQP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 09:16:15 -0400
Message-ID: <4DF0C79A.9090005@redhat.com>
Date: Thu, 09 Jun 2011 10:16:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/13] Reduce the gap between DVBv5 API and the specs
References: <20110608172311.0d350ab7@pedra> <201106082259.33770.hverkuil@xs4all.nl> <4DEFEBCA.1030909@redhat.com> <4DF0C1E2.5090202@linuxtv.org>
In-Reply-To: <4DF0C1E2.5090202@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andreas,

Em 09-06-2011 09:51, Andreas Oberritter escreveu:
> On 06/08/2011 11:38 PM, Mauro Carvalho Chehab wrote:
>> - all AUDIO*, OSD* and VIDEO* are used only by av7110 and ivtv.
>>
>> - The CA* ioctls are used by core (although several are only implemented
>>   inside a few drivers);
> 
> All (or most) of these ioctls (except OSD, which AFAIR has been
> deprecated since v3) are used by out-of-tree drivers. av7110 and ivtv
> just happen to be the only in-tree drivers supporting audio and video
> decoders.

We should not care with drivers that will never be upstream. 

Those out-of-tree drivers are there just because they're still being prepared for
submission, or because the driver maintainers decided that they won't submit
upstream?

In the first case, I think we should try to merge those drivers first, 
before taking any decision about any API removal/change. So, maybe we can
postpone any API removal decision to kernel 3.2, in order to merge those
drivers upstream.

Thanks,
Mauro.
