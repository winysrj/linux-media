Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54145 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751992AbZBPVjs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 16:39:48 -0500
Message-ID: <4999DD20.5080801@gmx.de>
Date: Mon, 16 Feb 2009 22:39:44 +0100
From: wk <handygewinnspiel@gmx.de>
MIME-Version: 1.0
To: Devin Heitmueller <devin.heitmueller@gmail.com>
CC: VDR User <user.vdr@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Subject: Re: DVB-API v5 questions and no dvb developer answering ?
References: <4999A6DD.7030707@gmx.de> <200902161908.15698.hverkuil@xs4all.nl>	 <a3ef07920902161037nf02b51dl2b411e33ddc76933@mail.gmail.com> <412bdbff0902161133u22febbc7v9ca9173bb547bb99@mail.gmail.com>
In-Reply-To: <412bdbff0902161133u22febbc7v9ca9173bb547bb99@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> As always we continue to welcome patches, including for the
> documentation.  Instead of bitching and moaning, how about you roll up
> your sleeves and actually help out?
>
> Let's try to remember that pretty much all the developers here are
> volunteers, so berating them for not doing things fast enough for your
> personal taste is not really very productive.
>
> Regards,
>
> Devin
>
>   
Devin,

can you please explain, how others should contribute to an dvb api if
- the only DVB API file to be found is a pdf file, and therefore not 
editable. Which files exactly to be edited you are writing of?
- one doesn't know which ioctls exist for what function, which return 
codes and arguments, how to understand and to use..?

What you suggest is almost impossible to someone not perfectly familiar 
with the drivers, only for dvb experts who have written at least a bunch 
of drivers.
Its something different than sending patches for one single driver where 
some bug/improvement was found.

On the other hand, in principle a driver without existing api doc is 
useless. Nobody can use it, the same for drivers with undocumented new 
features.

Regards,
Winfried

