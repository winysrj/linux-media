Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49721 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382Ab2GXVun (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 17:50:43 -0400
Message-ID: <500F18A5.4010602@iki.fi>
Date: Wed, 25 Jul 2012 00:50:29 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	workshop-2011@linuxtv.org
Subject: Re: Media summit at the Kernel Summit - was: Fwd: Re: [Ksummit-2012-discuss]
 Organising Mini Summits within the Kernel Summit
References: <20120713173708.GB17109@thunk.org> <5005A14D.8000809@redhat.com> <201207242305.08220.remi@remlab.net> <CAGoCfiwE1pfCxuE3WS3FwOV2jnxMFxhnL6-+hTSfE+2PNnxk-g@mail.gmail.com>
In-Reply-To: <CAGoCfiwE1pfCxuE3WS3FwOV2jnxMFxhnL6-+hTSfE+2PNnxk-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/24/2012 11:11 PM, Devin Heitmueller wrote:
> On Tue, Jul 24, 2012 at 4:05 PM, Rémi Denis-Courmont <remi@remlab.net> wrote:
>> If it's of interest to anyone, I could probably present a bunch of issues with
>> V4L2 and DVB from userspace perspective.
>
> Remi,
>
> I would strongly be in favor of this.  One thing that we get far to
> little of is feedback from actual userland developers making use of
> the V4L and DVB interfaces (aside from the SoC vendors, which is a
> completely different target audience than the traditional V4L and DVB
> consumers)

I wonder if it is wise to merge both DVB and V4L2 APIs, add needed DVB 
stuff to V4L2 API and finally remove whole DVB API. V4L2 API seems to be 
much more feature rich, developed more actively and maybe has less 
problems than current DVB API.


regards
Antti

-- 
http://palosaari.fi/
