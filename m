Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:5819 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZBQADK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 19:03:10 -0500
Received: by rv-out-0506.google.com with SMTP id g9so1247383rvb.5
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2009 16:03:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4999DD20.5080801@gmx.de>
References: <4999A6DD.7030707@gmx.de> <200902161908.15698.hverkuil@xs4all.nl>
	 <a3ef07920902161037nf02b51dl2b411e33ddc76933@mail.gmail.com>
	 <412bdbff0902161133u22febbc7v9ca9173bb547bb99@mail.gmail.com>
	 <4999DD20.5080801@gmx.de>
Date: Mon, 16 Feb 2009 16:03:09 -0800
Message-ID: <a3ef07920902161603x2c3bea3ar7728677d712197fd@mail.gmail.com>
Subject: Re: DVB-API v5 questions and no dvb developer answering ?
From: VDR User <user.vdr@gmail.com>
To: wk <handygewinnspiel@gmx.de>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 16, 2009 at 1:39 PM, wk <handygewinnspiel@gmx.de> wrote:
> Devin,
>
> can you please explain, how others should contribute to an dvb api if
> - the only DVB API file to be found is a pdf file, and therefore not
> editable. Which files exactly to be edited you are writing of?
> - one doesn't know which ioctls exist for what function, which return codes
> and arguments, how to understand and to use..?
>
> What you suggest is almost impossible to someone not perfectly familiar with
> the drivers, only for dvb experts who have written at least a bunch of
> drivers.
> Its something different than sending patches for one single driver where
> some bug/improvement was found.
>
> On the other hand, in principle a driver without existing api doc is
> useless. Nobody can use it, the same for drivers with undocumented new
> features.

Exactly!  Should be entertaining to hear the answers to everything but
the first 'what files do you edit', though the rest of the questions
will likely continue to be ignored.  It seems some think those not
familiar with s2api technical structure should reverse engineer it and
write the documentation rather then the people who actually created
it.  To even suggest such a thing is absurd in my humble opinion.
Talk about counter-productive...
