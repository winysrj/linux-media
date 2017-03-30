Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-2.goneo.de ([85.220.129.34]:33243 "EHLO smtp2-2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932638AbdC3LRl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 07:17:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170330071258.0ca47e4c@vento.lan>
Date: Thu, 30 Mar 2017 13:17:16 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <318BAC09-137D-4EA6-B2E9-C5BF0E01A769@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com> <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de> <87y3vn2mzk.fsf@intel.com> <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de> <20170330071258.0ca47e4c@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 30.03.2017 um 12:12 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>> At this point I'd just go with what Mauro has. It's here now, as
>>> patches. We've seen from the GPU documentation that polishing the
>>> one-time initial conversion is, after a point, wasted effort. Having the
>>> documentation in rst attracts more attention and contributions, and any
>>> remaining issues will get ironed out in rst.  
>> 
>> I totally agree with you (I have never said something different)
>> 
>>> This is also one reason I'm in favor of just bulk converting the rest of
>>> the .tmpl files using Documentation/sphinx/tmplcvt, get rid of DocBook
>>> and be done with it, and have the crowds focus on rst.  
>> 
>> I also agree with that. The tmplcvt script is good enough for this task,
>> the dbxml2rst tool is more elaborate.
> 
> I like the idea of a bulk conversion. My personal preference here is to
> use the tmplcvt for such task, at least for simple books like the ones
> I converted from USB.
> 
> The advantage is that it places everything on a single rst file, with,
> IMHO, works best for books that aren't too complex.
> Of course, it doesn't hurt to compare the end result with dbxml2rst
> and see if something could be improved.

If it helps ... dbxml2rst also supports single file conversion  ... I updated:

  https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated

There you find a folder for each DocBook conversion with only one rst file (index.rst)
in .. If you like, use it for comparison.

-- Markus --
