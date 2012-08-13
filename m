Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696Ab2HMVjq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 17:39:46 -0400
Message-ID: <50297418.4030906@redhat.com>
Date: Mon, 13 Aug 2012 18:39:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Walter Van Eetvelt <walter@van.eetvelt.be>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: RFC: V4L2 API ambiguities
References: <201208131427.56961.hverkuil@xs4all.nl> <8ed2a79057a0cc80ba058cebd97fd69d@mail.eetvelt.be> <CAGoCfiwJOt8LQYyGu0G=iJ-fAMyB82Y2jyZc4TS72QHOE9ZmnQ@mail.gmail.com>
In-Reply-To: <CAGoCfiwJOt8LQYyGu0G=iJ-fAMyB82Y2jyZc4TS72QHOE9ZmnQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 13-08-2012 18:31, Devin Heitmueller escreveu:
> On Mon, Aug 13, 2012 at 4:27 PM, Walter Van Eetvelt
> <walter@van.eetvelt.be> wrote:
>> For me there is a an issue in the V4L specs for the support of DVB-S/C/T
>> devices where the CI device is decoupled from the Tuners.
>> At the moment there is no standard solution on which device drivers
>> implementers and Application programmers can fall back.
> 
> DVB isn't part of the V4L spec.  There are *tons* of problems with
> DVB, none of which are being discussed in this meeting (out of scope).

No, it is not out of scope. The thing is that none of the developers
that are going to be there proposed a DVB-specific themes, unfortunately.

Yet, there are two themes there that are not V4L only: the userspace
discussions and the SoC discussions. I expect that it will focus at
the media API's as a hole, and not just V4L API.

Regards,
Mauro
