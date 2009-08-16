Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f205.google.com ([209.85.217.205]:61768 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZHPKQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Aug 2009 06:16:28 -0400
Received: by gxk1 with SMTP id 1so3266274gxk.17
        for <linux-media@vger.kernel.org>; Sun, 16 Aug 2009 03:16:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908151357.06045.hverkuil@xs4all.nl>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
	 <200908151357.06045.hverkuil@xs4all.nl>
Date: Sun, 16 Aug 2009 13:16:28 +0300
Message-ID: <a0580c510908160316v3ced65b2jb4eb5ac5c632aa0a@mail.gmail.com>
Subject: Re: [PATCHv15 2/8] v4l2: video device: Add V4L2_CTRL_CLASS_FM_TX
	controls
From: Eduardo Valentin <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	ext Mauro Carvalho Chehab <mchehab@infradead.org>,
	ext Douglas Schilling Landgraf <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

<snip>

>
> Hi Eduardo,
>
> I would like to make some small changes here: the control IDs do not have to
> be consecutive so I think it is better to leave some gaps between the various
> sections: e.g. let the AUDIO controls start at BASE + 64 (leaving more than
> enough room for additional RDS controls). Between PTY and PS_NAME we should
> skip one control since I'm sure at some time in the future a PTY_NAME will
> appear. A comment like '/* placeholder for future PTY_NAME control */' would
> be useful as well.

I think leaving room for following controls would be good. No problem to leave
some space left already in between these ID's.

About the comment for PTY_NAME, I also agree with you.

>
> The AUDIO_COMPRESSION controls can start at BASE + 80, the PILOT controls at
> BASE + 96 and the last set of controls at BASE + 112.

Right.

>
> BTW, wouldn't it be slightly more consistent if V4L2_CID_FM_TX_PREEMPHASIS is
> renamed to V4L2_CID_TUNE_PREEMPHASIS? It's a bit of an odd one out at the
> moment.

Right. Good. Better to aggregate it into the *_TUNE_* controls. Which
makes sense for me.

>
> Note that I've verified my compat32 implementation for strings: it's working
> correctly on my 64-bit machine (I hacked a string control into vivi.c to do
> the testing).

Right.

>
> If you agree with these proposed changes, then I can modify the patch myself,
> no need for a new patch series.

Ok then. You can proceed with these changes. No problem from my side.

>
> Regards,
>
>        Hans


BR,

-- 
Eduardo Bezerra Valentin
