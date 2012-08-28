Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe09.c2i.net ([212.247.155.2]:50555 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753199Ab2H1VAs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 17:00:48 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH, RFC] Fix DVB ioctls failing if frontend open/closed too fast
Date: Tue, 28 Aug 2012 22:56:41 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Juergen Lock <nox@jelal.kn-bremen.de>
References: <20120731222216.GA36603@triton8.kn-bremen.de> <502711BE.4020701@redhat.com> <CAGoCfiyBZNkFkvhCqsbwxVaANZcp+1df-0eAmzrpzfavD6A+dQ@mail.gmail.com>
In-Reply-To: <CAGoCfiyBZNkFkvhCqsbwxVaANZcp+1df-0eAmzrpzfavD6A+dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208282256.41157.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 12 August 2012 05:06:49 Devin Heitmueller wrote:
> On Sat, Aug 11, 2012 at 10:15 PM, Mauro Carvalho Chehab
> 
> <mchehab@redhat.com> wrote:
> > Devin/Antti,
> > 
> > As Juergen mentioned your help on this patch, do you mind helping
> > reviewing and testing it?
> 
> I guided Juergen through the creation of the patch via #linuxtv a
> couple of weeks ago.  While I'm generally confident that it should
> work (and it does address his basic issue), I hadn't had the time to
> stare at the code long enough to see what other side effects it might
> produce.
> 
> I'm tied up in other projects right now and am not confident I will
> have cycles to look at this closer.  Antti, if you want to give it
> some cycles, this would be a good fix to get upstream (and you've
> already been looking at dvb_frontend.c for quite a while, so I believe
> you would be able to spot a problem if one exists).
> 
> Devin

Hi,

What is the status of this PATCH? Submitted or under testing ??

--HPS
