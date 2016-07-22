Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47250
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbcGVJqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 05:46:12 -0400
Date: Fri, 22 Jul 2016 06:46:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160722064604.5e4cbe64@recife.lan>
In-Reply-To: <F30ED754-B987-44B1-B839-9305D7FC1533@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
	<99F50AA7-01F0-4659-82F9-558E19B3855A@darmarit.de>
	<20160719141843.17bf5a9b@recife.lan>
	<F30ED754-B987-44B1-B839-9305D7FC1533@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 21 Jul 2016 17:17:26 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 19.07.2016 um 19:18 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> >> A bit OT, but I see that you often use tabs / I recommend to use 
> >> spaces for indentation:
> >> 
> >> http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#whitespace  
> > 
> > The Kernel policies are to use tabs instead of spaces,  
> 
> Yes, but not in text files .. I think.

See chapter 1 of Documentation/CodingStyle:

			Chapter 1: Indentation

	Tabs are 8 characters, and thus indentations are also 8 characters.




> 
> -- Markus --
> 
> > and tabs have
> > size of 8. I have some git automation to avoid commit patches with
> > bad whitespaces, and some tools to convert spaces into tabs.  
> 
> > 
> > 
> > Thanks,
> > Mauro
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 


Thanks,
Mauro
