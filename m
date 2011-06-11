Return-path: <mchehab@pedra>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1752 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1FKRCQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 13:02:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
Date: Sat, 11 Jun 2011 19:02:11 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl> <4a3fc9cd-d7e1-4692-92cb-af4d652c0224@email.android.com> <BANLkTikJbhC--Qp4KUBjFdrCMuvvoMuxaA@mail.gmail.com>
In-Reply-To: <BANLkTikJbhC--Qp4KUBjFdrCMuvvoMuxaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106111902.11384.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, June 11, 2011 18:57:16 Devin Heitmueller wrote:
> On Sat, Jun 11, 2011 at 12:06 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> > Devin,
> >
> > I think I have a Gotview or compro card with an xc2028.  Is that tuner capable of standby?  Would the cx18 or ivtv driver need to actively support using stand by?
> 
> An xc2028/xc3028 should be fine, as that does support standby.  The
> problems we saw with VLC were related to calls like G_TUNER returning
> prematurely if the device was in standby, leaving the returned
> structure populated with garbage.

OK, but how do you get it into standby in the first place? (I must be missing
something here...)

Regards,

	Hans
