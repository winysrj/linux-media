Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:60332 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbcHISig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2016 14:38:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 0/3] doc-rst: more generic way to build only sphinx sub-folders
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160809150223.28fca182@recife.lan>
Date: Tue, 9 Aug 2016 20:37:57 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <700377AA-3221-46F3-82DE-7FD3FEE2C23F@darmarit.de>
References: <1470662100-6927-1-git-send-email-markus.heiser@darmarit.de> <20160809092108.266f37c2@lwn.net> <20160809150223.28fca182@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 09.08.2016 um 20:02 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 9 Aug 2016 09:21:08 -0600
> Jonathan Corbet <corbet@lwn.net> escreveu:
> 
>> On Mon,  8 Aug 2016 15:14:57 +0200
>> Markus Heiser <markus.heiser@darmarit.de> wrote:
>> 
>>> this is my approach for a more generic way to build only sphinx sub-folders, we
>>> discussed in [1]. The last patch adds a minimal conf.py to the gpu folder, if
>>> you don't want to patch the gpu folder drop it.  
>> 
>> I haven't had a chance to really mess with this yet, but it seems like a
>> reasonable solution. 
> 
> Agreed.
> 
>> Mauro, does it give you what you need?
> 
> Yes. Just tested it here, and it works fine, allowing to build
> everything, just one of the books and the media book with the nitpick
> configuration.
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Hi Mauro and Jon,

thanks for testing and ack.

-- Markus --

