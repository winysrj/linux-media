Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46511
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932663AbdC3MKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 08:10:55 -0400
Date: Thu, 30 Mar 2017 09:10:44 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
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
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
Message-ID: <20170330091044.74d60342@vento.lan>
In-Reply-To: <318BAC09-137D-4EA6-B2E9-C5BF0E01A769@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com>
        <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de>
        <87y3vn2mzk.fsf@intel.com>
        <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de>
        <20170330071258.0ca47e4c@vento.lan>
        <318BAC09-137D-4EA6-B2E9-C5BF0E01A769@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 13:17:16 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 30.03.2017 um 12:12 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> >>> At this point I'd just go with what Mauro has. It's here now, as
> >>> patches. We've seen from the GPU documentation that polishing the
> >>> one-time initial conversion is, after a point, wasted effort. Having the
> >>> documentation in rst attracts more attention and contributions, and any
> >>> remaining issues will get ironed out in rst.    
> >> 
> >> I totally agree with you (I have never said something different)
> >>   
> >>> This is also one reason I'm in favor of just bulk converting the rest of
> >>> the .tmpl files using Documentation/sphinx/tmplcvt, get rid of DocBook
> >>> and be done with it, and have the crowds focus on rst.    
> >> 
> >> I also agree with that. The tmplcvt script is good enough for this task,
> >> the dbxml2rst tool is more elaborate.  
> > 
> > I like the idea of a bulk conversion. My personal preference here is to
> > use the tmplcvt for such task, at least for simple books like the ones
> > I converted from USB.
> > 
> > The advantage is that it places everything on a single rst file, with,
> > IMHO, works best for books that aren't too complex.
> > Of course, it doesn't hurt to compare the end result with dbxml2rst
> > and see if something could be improved.  
> 
> If it helps ... dbxml2rst also supports single file conversion  ... I updated:
> 
>   https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated

Ok, I double-checked the results from dbxml2rst with pandoc (via
the script). Those are the differences after running the following commands:

	$ wget https://raw.githubusercontent.com/return42/sphkerneldoc/master/Documentation/books_migrated/writing_usb_driver/index.rst
	$ Documentation/sphinx/tmplcvt Documentation/DocBook/writing_usb_driver.tmpl writing_usb_driver.rst
	$ diff -uprBw writing_usb_driver.rst index.rst 

1) Author data:

-:Author: Greg Kroah-Hartman
+:author:    Kroah-Hartman Greg
+:address:   greg@kroah.com

dbxml2rst inverted the author's name.  It also added author's e-mail.

IMHO, it is better to not have email address there, as it could be
outdated, but this is just my personal preference.

2) dbxml2rst added a copyright information:

+**Copyright** 2001-2002 : Greg Kroah-Hartman

This is a good thing.

3) dbxml2rst added a GPL information.

IMHO, we should add just one GPL information, per hole book
(and not per converted file).

4) dbxml2rst created some references that won't be unique:

+.. _intro:

That's a bad thing, as I bet most converted documents will have "intro"
sections.

5) dbxml2rst use ".. code-block:: c" instead of "::"

I prefer using "::"

6) dbxml2rst appends a commentary at the end:

+.. ------------------------------------------------------------------------------
+.. This file was automatically converted from DocBook-XML with the dbxml
+.. library (https://github.com/return42/dbxml2rst). The origin XML comes
+.. from the linux kernel:
+..
+..   http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
+.. ------------------------------------------------------------------------------

7) dbxml2rst did a worse job with URB conversions:

-USB Home Page: http://www.usb.org
+USB Home Page: `http://www.usb.org <http://www.usb.org>`__

So, in summary, at least for this document, the only thing good with
dbxml2rst was that it filled the copyright info.

Maybe for more complex documents, it would do a better job.

Yet, in order to standardize it everywhere, I guess the best would be to
produce copyright data like:

	.. include:: <isonum.txt>

	:Copyright: |copy| 2001-2002 : Greg Kroah-Hartman

Regards,
Mauro
