Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbZLYVWC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 16:22:02 -0500
Message-ID: <4B352CE4.7070103@redhat.com>
Date: Fri, 25 Dec 2009 19:21:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Akihiro TSUKADA <tskd2@yahoo.co.jp>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com> <4B34DB3C.6010805@yahoo.co.jp>
In-Reply-To: <4B34DB3C.6010805@yahoo.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-12-2009 13:33, Akihiro TSUKADA escreveu:
> 
> Hi Mauro,
> 
>>> I wrote several patches those days in order to allow dvb-apps to properly
>>> parse ISDB-T channel.conf.
>  
> I think it would be convenient if channel.conf allows
> the kind of format of PROPNAME=VALUE list, for readability and extensibility
> of the conf file.
> 
> there are already so many parameters in ISDB-T,
> so it is a bit difficult for the users to remember and correctly specify
> all the field in the right order.
> besides they have to be careful in counting the delimiter character
>  when some (most?) parameters can be omitted or be left to the device/region default.
> 
> and when I consider extending this lib to ISDB-S (for example),
> I have to add "TS-id" parameter,
> which leads to the re-definition of the data structure and requires re-building.
> So, it would be convenient if I could write for example like,
> DTV_FREQUENCY=1049480:DTV_ISDBS_TS_ID=1

It shouldn't be hard to add it, by writing a new parser file and a new dump file.
Currently, there are two parser files and two dump files: one for vdr and one for
zap format.

I opted to not do it to avoid breaking compatibility with those two applications.

Cheers,
Mauro.
