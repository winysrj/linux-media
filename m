Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1JHMMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Oct 2011 08:12:48 -0400
Message-ID: <4E903E3B.8050408@redhat.com>
Date: Sat, 08 Oct 2011 09:12:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
References: <201110061423.22064.hverkuil@xs4all.nl> <CAHFNz9KPXY-z+zq0iSE3O66GaDj-2MA8vWO21KLbjN9tw6RZ-w@mail.gmail.com>
In-Reply-To: <CAHFNz9KPXY-z+zq0iSE3O66GaDj-2MA8vWO21KLbjN9tw6RZ-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-10-2011 15:08, Manu Abraham escreveu:
> On Thu, Oct 6, 2011 at 5:53 PM, Hans Verkuil<hverkuil@xs4all.nl>  wrote:
>> Currently we have three repositories containing libraries and utilities that
>> are relevant to the media drivers:
>>
>> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
>> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
>> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>>
>> It makes no sense to me to have three separate repositories, one still using
>> mercurial and one that isn't even on linuxtv.org.
>
> We had a discussion earlier on the same subject wrt dvb-apps and the
> decision at that time was against a merge. That decision still holds.

Yes, years ago when v4l-utils tree were created. Since them, there was several
major releases of it, and not a single release of dvb-apps, with, btw, still
lacks proper support for DVB APIv5.

So, why not discuss it again?

>
> Regards,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

