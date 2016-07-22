Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:38552 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbcGVKzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 06:55:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160722064604.5e4cbe64@recife.lan>
Date: Fri, 22 Jul 2016 12:55:30 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4A93290F-A7CF-4B22-90DF-009D0DC294E2@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com> <578DF08F.8080701@xs4all.nl> <20160719081259.482a8c04@recife.lan> <6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de> <20160719115319.316349a7@recife.lan> <99F50AA7-01F0-4659-82F9-558E19B3855A@darmarit.de> <20160719141843.17bf5a9b@recife.lan> <F30ED754-B987-44B1-B839-9305D7FC1533@darmarit.de> <20160722064604.5e4cbe64@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 22.07.2016 um 11:46 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Thu, 21 Jul 2016 17:17:26 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Am 19.07.2016 um 19:18 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>> 
>>>> A bit OT, but I see that you often use tabs / I recommend to use 
>>>> spaces for indentation:
>>>> 
>>>> http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#whitespace  
>>> 
>>> The Kernel policies are to use tabs instead of spaces,  
>> 
>> Yes, but not in text files .. I think.
> 
> See chapter 1 of Documentation/CodingStyle:
> 
> 			Chapter 1: Indentation
> 
> 	Tabs are 8 characters, and thus indentations are also 8 characters.

Hi Mauro,

sorry if I'am pedantic, IMHO this is "Coding" style. 

See end of chapter 1:

  Outside of comments, documentation and except in Kconfig, spaces are never
  used for indentation ...

As far as I can see, nearly all of the ASCII markups in the *.txt files use
space for indentation (some mix tabs and spaces). I don't know if 
tab indentation in kernel-doc comments is a good choice.

--Markus