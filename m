Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:9348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933144Ab1ETOnX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 May 2011 10:43:23 -0400
Message-ID: <4DD67E03.4070002@redhat.com>
Date: Fri, 20 May 2011 11:43:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
References: <20110517105417.1b96f66c@tele> <20110517113637.923e0da2.ospite@studenti.unina.it>
In-Reply-To: <20110517113637.923e0da2.ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-05-2011 06:36, Antonio Ospite escreveu:
> On Tue, 17 May 2011 10:54:17 +0200
> Jean-Francois Moine <moinejf@free.fr> wrote:
> 
>> The following changes since commit
>> f9b51477fe540fb4c65a05027fdd6f2ecce4db3b:
>>
>>   [media] DVB: return meaningful error codes in dvb_frontend (2011-05-09 05:47:20 +0200)
>>
>> are available in the git repository at:
>>   git://linuxtv.org/jfrancois/gspca.git for_v2.6.40
>>
> [...]
> 
> Hi Jean-Francois, sometimes it is useful to add also a "why" section to
> commit messages so others can follow your thoughts, and even learn from
> them.
> 
> I have this very simple scheme: a summary of the "what" goes into the
> short commit message and the "why" and "how" go into the long commit
> message when they are not immediately trivial from the code; for
> instance the "why" of the USB trace changes in this series wasn't
> trivial to me.

Yeah, providing a good documentation is important to allow the others to know what's
happening at the driver.

Jean-Francois,

Could you please add more comments to your patch series? I'll discard this pull
request from my queue. So, feel free to re-base your tree if you need.

Thanks,
Mauro
