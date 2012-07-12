Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932953Ab2GLUzB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 16:55:01 -0400
Message-ID: <4FFF39CA.3050609@redhat.com>
Date: Thu, 12 Jul 2012 22:55:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	halli manjunatha <hallimanju@gmail.com>
Subject: Re: [PATCH 1/5] v4l2: Add rangelow and rangehigh fields to the v4l2_hw_freq_seek
 struct
References: <1342021658-27821-1-git-send-email-hdegoede@redhat.com> <201207112001.18960.hverkuil@xs4all.nl> <4FFDC7DA.1090808@redhat.com> <201207121127.06460.hverkuil@xs4all.nl>
In-Reply-To: <201207121127.06460.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/12/2012 11:27 AM, Hans Verkuil wrote:
> On Wed 11 July 2012 20:37:14 Hans de Goede wrote:

<snip>

>>> 2) What happens if the current frequency is outside the low/high range? The
>>> hwseek spec says that the seek starts from the current frequency, so that might
>>> mean that hwseek returns -ERANGE in this case.
>>
>> What the si470x code currently does is just clamp the frequency to the new
>> range before seeking, but -ERANGE works for me too.
>
> Clamping is a better idea IMHO as long as it is documented.

Ok, I've respun this patch to improve the documentation in various parts, I'm
resending the entire set right after this email.

Regards,

Hans

p.s.

Tomorrow morning I'm leaving for a week of vacation, during which I won't be
reading my mail. If everybody agrees on the 2nd revision of this patchset
please add it to your bands2 branch, and if you agree that this seems to be
it wrt the API for tuner-bands, you could also consider sending a pull-req
for it to Mauro for 3.6 :)




