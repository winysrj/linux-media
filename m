Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:42350 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbcHMOjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2016 10:39:00 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/3] doc-rst: generic way to build only sphinx sub-folders
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160812152020.21754cf8@lwn.net>
Date: Sat, 13 Aug 2016 16:38:14 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8DE431CA-5ADB-4D65-B2B4-1BBF58D3EF60@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de> <1470662100-6927-2-git-send-email-markus.heiser@darmarit.de> <20160812152020.21754cf8@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 12.08.2016 um 23:20 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Mon,  8 Aug 2016 15:14:58 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> Remove the 'DOC_NITPIC_TARGETS' from main $(srctree)/Makefile and add a
>> more generic way to build only a reST sub-folder.
>> 
> 
> So I went to apply these, but this one, at least, doesn't apply.  Could I
> get you to respin the series against current mainline (or docs-next)?
> 
> Thanks,
> 
> jon

Yes, it was based on Mauro's experimantal mchehab/docs-next. Since
Mauro is on a journey, I merged it on top of your docs-next and send
the *consolidation* patch

  https://www.mail-archive.com/linux-media@vger.kernel.org/msg101262.html

@Mauro: I hope this is OK for you?

-- Markus --


 
