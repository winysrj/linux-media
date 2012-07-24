Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37594 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2GXVxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jul 2012 17:53:48 -0400
Received: by vbbff1 with SMTP id ff1so49050vbb.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jul 2012 14:53:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <500F18A5.4010602@iki.fi>
References: <20120713173708.GB17109@thunk.org>
	<5005A14D.8000809@redhat.com>
	<201207242305.08220.remi@remlab.net>
	<CAGoCfiwE1pfCxuE3WS3FwOV2jnxMFxhnL6-+hTSfE+2PNnxk-g@mail.gmail.com>
	<500F18A5.4010602@iki.fi>
Date: Tue, 24 Jul 2012 17:53:47 -0400
Message-ID: <CAHAyoxyFAAa9pkNz5khsyVpdvROduw7vYNDbDG_HcNK8iouwkw@mail.gmail.com>
Subject: Re: [Workshop-2011] Media summit at the Kernel Summit - was: Fwd: Re:
 [Ksummit-2012-discuss] Organising Mini Summits within the Kernel Summit
From: Michael Krufky <mkrufky@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 24, 2012 at 5:50 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 07/24/2012 11:11 PM, Devin Heitmueller wrote:
>>
>> On Tue, Jul 24, 2012 at 4:05 PM, Rémi Denis-Courmont <remi@remlab.net>
>> wrote:
>>>
>>> If it's of interest to anyone, I could probably present a bunch of issues
>>> with
>>> V4L2 and DVB from userspace perspective.
>>
>>
>> Remi,
>>
>>
>> I would strongly be in favor of this.  One thing that we get far to
>> little of is feedback from actual userland developers making use of
>> the V4L and DVB interfaces (aside from the SoC vendors, which is a
>> completely different target audience than the traditional V4L and DVB
>> consumers)
>
>
> I wonder if it is wise to merge both DVB and V4L2 APIs, add needed DVB stuff
> to V4L2 API and finally remove whole DVB API. V4L2 API seems to be much more
> feature rich, developed more actively and maybe has less problems than
> current DVB API.

lets never do that.
