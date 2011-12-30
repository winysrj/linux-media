Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1L3KxT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 05:53:19 -0500
Message-ID: <4EFD985A.4050301@redhat.com>
Date: Fri, 30 Dec 2011 11:54:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH for 3.2 URGENT] gspca: Fix bulk mode cameras no longer
 working (regression fix)
References: <1325191002-25074-1-git-send-email-hdegoede@redhat.com> <1325191002-25074-2-git-send-email-hdegoede@redhat.com> <20111230112121.03e8b59b@tele>
In-Reply-To: <20111230112121.03e8b59b@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/30/2011 11:21 AM, Jean-Francois Moine wrote:
> On Thu, 29 Dec 2011 21:36:42 +0100
> Hans de Goede<hdegoede@redhat.com>  wrote:
>
>> The new iso bandwidth calculation code accidentally has broken support
>> for bulk mode cameras. This has broken the following drivers:
>> finepix, jeilinj, ovfx2, ov534, ov534_9, se401, sq905, sq905c, sq930x,
>> stv0680, vicam.
>>
>> Thix patch fixes this. Fix tested with: se401, sq905, sq905c, stv0680&  vicam
>> cams.
>
> Hi Hans,
>
> Sorry for I should not be fully awoken yet, but I don't understand the
> problem from your fix.
>
> The patch just sets the altsetting to the highest one for bulk
> transfer. Does this mean that, in this case, the altsetting table
> created by build_ep_tb is wrong and the highest altsetting cannot
> selected?

Most bulk mode cameras have only one altsetting, altsetting 0, which is
seen as invalid by build_ep_tb, since it is invalid for isoc mode, resulting
in the cameras not working with a: "no transfer endpoint found" error.

I've opted to fix things by causing build_ep_tb to not be called for
bulk mode cameras at all, since doing bandwidth calculations for
bulk mode makes no sense. bulk transfers get whatever bandwidth is
left on the bus, there is no guarantee that there are 1000 / interval
packets a second like there is with isoc transfers, so the bandwidth
is unknown. Also note that because of this interval is 0 for bulk
endpoints, since it is unused. So calling build_ep_tb for bulk mode
transfers makes no sense.

WRT just choosing the highest numbered alt setting this is because
some bulk mode cameras (stv0680 based ones) report 2 alt settings
(which makes no sense for bulk mode, but they do it anyways),
with alt setting 0 not listing any endpoints at all, and alt setting
1 listening the bulk endpoint we want, so by picking the highest alt
setting we end up with picking the one and only alt setting most cameras
have and picking one which actually has the bulk endpoint listed for
weird cases like the stv0680 based ones.

Note that I'm spending most of my time today on testing the new
bandwidth code with various cameras, I'll send you a patchset
with some more proposed patches today. We should then evaluate
if we want to get those into 3.2 too. I send this one yesterday since
it fixes a large bunch of cameras not working at all and it is a
simple and safe fix IMHO.

Regards,

Hans



