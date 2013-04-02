Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33990 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3DBAs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Apr 2013 20:48:57 -0400
Received: by mail-qc0-f173.google.com with SMTP id b12so1337216qca.32
        for <linux-media@vger.kernel.org>; Mon, 01 Apr 2013 17:48:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130401191427.5d81fbc4@redhat.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
	<CAGoCfiwB9BT2mDQqu2cwsRM-0eraqyxdY0V3fnH+S2RSNiGSdQ@mail.gmail.com>
	<51378067.3000506@googlemail.com>
	<20130318182205.44f44e20@redhat.com>
	<5159C05B.10902@googlemail.com>
	<20130401162205.379bda4f@redhat.com>
	<5159F080.1030503@googlemail.com>
	<20130401191224.4da92bd8@redhat.com>
	<20130401191427.5d81fbc4@redhat.com>
Date: Mon, 1 Apr 2013 20:48:56 -0400
Message-ID: <CAGoCfiyaD_9T6OBKaiDGC7Mkme6EgDb7D9nEHd=pSYgSnk86+g@mail.gmail.com>
Subject: Re: [PATCH 0/3] em28xx: add support for two buses on em2874 and upper
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 1, 2013 at 6:14 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> In time, I meant to say:
>         "So, it seems very unlikely that any change here will keep it working for
>          model 16009 while breaking it for other HVR-930 devices."

As far as I know, there's only ever been one em28xx/drxk variant of
the 930c.  And since it was obsoleted a while ago I don't see any
reason you will see any minor revisions of this board design in the
future (the current design uses the cx231xx).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
