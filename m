Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2HMVzN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 17:55:13 -0400
Message-ID: <502977B8.8030201@redhat.com>
Date: Mon, 13 Aug 2012 18:55:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Walter Van Eetvelt <walter@van.eetvelt.be>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl> <8ed2a79057a0cc80ba058cebd97fd69d@mail.eetvelt.be> <CAGoCfiwJOt8LQYyGu0G=iJ-fAMyB82Y2jyZc4TS72QHOE9ZmnQ@mail.gmail.com> <50297418.4030906@redhat.com> <CAGoCfiyi9SRfz=wE18O6mO4z2G0=UVJgfrkx2O+tZ4nwBiARAA@mail.gmail.com>
In-Reply-To: <CAGoCfiyi9SRfz=wE18O6mO4z2G0=UVJgfrkx2O+tZ4nwBiARAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-08-2012 18:42, Devin Heitmueller escreveu:
> On Mon, Aug 13, 2012 at 5:39 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> No, it is not out of scope. The thing is that none of the developers
>> that are going to be there proposed a DVB-specific themes, unfortunately.
>>
>> Yet, there are two themes there that are not V4L only: the userspace
>> discussions and the SoC discussions. I expect that it will focus at
>> the media API's as a hole, and not just V4L API.
> 
> I'm talking specifically about a discussion of "V4L2 API Ambiguities",
> which is the topic of this thread and the meeting in question.

OK. With that regards, you're right.

> I
> realize other parts of the conference include DVB.  If you want me to
> start piling onto this thread will all the problems/deficiencies
> related to our DVB API, we can certainly do that.  However, none of
> the people on this thread will have any real insight into them given
> those individuals focus entirely on V4L2.

Yeah, but anyway we can try to cover the points that Walter
made during the DVB topics.

I suspect, however, that we need an RFC with a proposal for CI
decoupled from the demux, in order to be able to discuss it.

Regards,
Mauro
