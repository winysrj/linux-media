Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab1DZLLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Apr 2011 07:11:04 -0400
Message-ID: <4DB6A87A.2000906@redhat.com>
Date: Tue, 26 Apr 2011 13:11:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Ondrej Zary <linux@rainbow-software.org>,
	Joerg Heckenbach <joerg@heckenbach-aw.de>,
	Dwaine Garden <dwainegarden@rogers.com>,
	linux-media@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbvision: remove (broken) image format conversion
References: <201104252323.20420.linux@rainbow-software.org> <201104260832.11150.hverkuil@xs4all.nl>
In-Reply-To: <201104260832.11150.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 04/26/2011 08:32 AM, Hans Verkuil wrote:
> On Monday, April 25, 2011 23:23:17 Ondrej Zary wrote:
>> The YVU420 and YUV422P formats are broken and cause kernel panic on use.
>> (YVU420 does not work and sometimes causes "unable to handle paging request"
>> panic, YUV422P always causes "NULL pointer dereference").
>>
>> As V4L2 spec says that drivers shouldn't do any in-kernel image format
>> conversion, remove it completely (except YUYV).
>
> What really should happen is that the conversion is moved to libv4lconvert.
> I've never had the time to tackle that, but it would improve this driver a
> lot.
>
> Would you perhaps be interested in doing that work?
>

Seconded! I would be more then happy to help with the libv4l part (in the form
of review + merging + advice).

Regards,

Hans
