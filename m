Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:37483 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3DBTFp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 15:05:45 -0400
Received: by mail-ee0-f51.google.com with SMTP id c4so383084eek.24
        for <linux-media@vger.kernel.org>; Tue, 02 Apr 2013 12:05:44 -0700 (PDT)
Message-ID: <515B2C47.8020601@googlemail.com>
Date: Tue, 02 Apr 2013 21:06:47 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and upper
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com> <CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com> <51378067.3000506@googlemail.com> <20130318182205.44f44e20@redhat.com> <5159C05B.10902@googlemail.com> <20130401162205.379bda4f@redhat.com> <5159F080.1030503@googlemail.com> <20130401191224.4da92bd8@redhat.com> <20130401191427.5d81fbc4@redhat.com> <CAGoCfiyaD_9T6OBKaiDGC7Mkme6EgDb7D9nEHd=pSYgSnk86+g@mail.gmail.com>
In-Reply-To: <CAGoCfiyaD_9T6OBKaiDGC7Mkme6EgDb7D9nEHd=pSYgSnk86+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.04.2013 02:48, schrieb Devin Heitmueller:
> On Mon, Apr 1, 2013 at 6:14 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> In time, I meant to say:
>>         "So, it seems very unlikely that any change here will keep it working for
>>          model 16009 while breaking it for other HVR-930 devices."
> As far as I know, there's only ever been one em28xx/drxk variant of
> the 930c.  And since it was obsoleted a while ago I don't see any
> reason you will see any minor revisions of this board design in the
> future (the current design uses the cx231xx).

Are the em28xx devices model 16xxx and the newer cx231xx devices model
111xxx ?

Frank

>
> Devin
>

