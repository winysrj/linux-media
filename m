Return-path: <mchehab@pedra>
Received: from p-mail2.rd.francetelecom.com ([195.101.245.16]:21400 "EHLO
	p-mail2.rd.francetelecom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756528Ab0JAPMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Oct 2010 11:12:08 -0400
From: "Yann E. MORIN" <yann.morin.1998@anciens.enib.fr>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] v4l/dvb: add support for AVerMedia AVerTV Red HD+ (A850T)
Date: Fri, 1 Oct 2010 17:05:55 +0200
Cc: Eric.Valette@free.fr, Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1285795123-11046-1-git-send-email-yann.morin.1998@anciens.enib.fr> <4CA5CED7.2090203@Free.fr> <4CA5F5DE.7070209@redhat.com>
In-Reply-To: <4CA5F5DE.7070209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010011705.55459.yann.morin.1998@anciens.enib.fr>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hell all!

On Friday 01 October 2010 165318 Mauro Carvalho Chehab wrote:
> If you're talking about http://linuxtv.org/repo/, I just updated it.

Just nit-picking here, but the instructions still have some typoes:

git remote add linuxtv git://linuxtv.org/media-tree.git
-> the name of the tree uses a '_'            ^

git pull . remotes/staging/v2.6.37
-> should be (at least the above does not work for me):
git pull . remotes/linuxtv/staging/v2.6.37

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   ^                |
| --==< O_o >==-- '------------.-------:  X  AGAINST      |  /e\  There is no  |
| http://ymorin.is-a-geek.org/ | (*_*) | / \ HTML MAIL    |  """  conspiracy.  |
'------------------------------'-------'------------------'--------------------'
