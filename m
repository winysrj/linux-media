Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp12.mail.tnz.yahoo.co.jp ([203.216.226.140]:42874 "HELO
	smtp12.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753150AbZLYPkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2009 10:40:39 -0500
Message-ID: <4B34DB3C.6010805@yahoo.co.jp>
Date: Sat, 26 Dec 2009 00:33:16 +0900
From: Akihiro TSUKADA <tskd2@yahoo.co.jp>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] dvb-apps ported for ISDB-T
References: <4B32CF33.3030201@redhat.com> <4B342CEE.8020205@redhat.com>
In-Reply-To: <4B342CEE.8020205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Mauro,

>> I wrote several patches those days in order to allow dvb-apps to properly
>> parse ISDB-T channel.conf.
 
I think it would be convenient if channel.conf allows
the kind of format of PROPNAME=VALUE list, for readability and extensibility
of the conf file.

there are already so many parameters in ISDB-T,
so it is a bit difficult for the users to remember and correctly specify
all the field in the right order.
besides they have to be careful in counting the delimiter character
 when some (most?) parameters can be omitted or be left to the device/region default.

and when I consider extending this lib to ISDB-S (for example),
I have to add "TS-id" parameter,
which leads to the re-definition of the data structure and requires re-building.
So, it would be convenient if I could write for example like,
DTV_FREQUENCY=1049480:DTV_ISDBS_TS_ID=1

regards,
akihiro
--------------------------------------
Get Disney character's mail address on Yahoo! Mail
http://pr.mail.yahoo.co.jp/disney/
