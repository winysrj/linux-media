Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38006 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbbBPOqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 09:46:53 -0500
Message-ID: <54E202C5.7070904@xs4all.nl>
Date: Mon, 16 Feb 2015 15:46:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv4 15/25] [media] tuner-core: properly initialize media
 controller subdev
References: <cover.1423867976.git.mchehab@osg.samsung.com>	<5c8a3752af88ba4c349d9d2416cad937f96a0423.1423867976.git.mchehab@osg.samsung.com>	<54E1B3F0.7060807@xs4all.nl>	<20150216085925.3b52a558@recife.lan> <CAGoCfiy+te9GRt=xPrHmUe+ckeO2X0u3XmJC77BSQG6VJ_aEFw@mail.gmail.com>
In-Reply-To: <CAGoCfiy+te9GRt=xPrHmUe+ckeO2X0u3XmJC77BSQG6VJ_aEFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/16/2015 03:39 PM, Devin Heitmueller wrote:
>> Except for PVR-500, I can't remember any case where the same tuner is used
>> more than once.
>>
>> There is the case of a device with two tuners, one for TV and another one
>> for FM. Yet, on such case, the name of the FM tuner will be different,
>> anyway. So, I don't think this is a current issue, but if the name should
>> be unique, then we need to properly document it.
> 
> Perhaps I've misunderstood the comment, but HVR-2200/2250 and numerous
> dib0700 designs are dual DVB tuners.  Neither are like the PVR-500 in
> that they are a single entity with two tuners (as opposed to the
> PVR-500 which is two PCI devices which happen to be on the same PCB).

DVB, yes, but not analog (V4L2) tuners. For DVB tuners the frontend name
is used as the entity name, which I assumed is unique. It is, right? If
that's not unique, then the same issue is there as well. I have ordered
a dual DVB-T board, but I won't have that for another two weeks.

Regards,

	Hans
