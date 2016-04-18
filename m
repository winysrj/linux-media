Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:47961 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbcDRJub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 05:50:31 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160412094620.4fbf05c0@lwn.net>
Date: Mon, 18 Apr 2016 11:49:07 +0200
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2F8742C2-A90A-4CC3-BCE0-937E129D3D59@darmarit.de>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan> <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com> <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan> <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonahtan,

Am 12.04.2016 um 17:46 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Fri, 8 Apr 2016 17:12:27 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> motivated by this MT, I implemented a toolchain to migrate the kernel’s 
>> DocBook XML documentation to reST markup. 
>> 
>> It converts 99% of the docs well ... to gain an impression how 
>> kernel-docs could benefit from, visit my sphkerneldoc project page
>> on github:
>> 
>>  http://return42.github.io/sphkerneldoc/
> 
> So I've obviously been pretty quiet on this recently.  Apologies...I've
> been dealing with an extended death-in-the-family experience, and there is
> still a fair amount of cleanup to be done.
> 
> Looking quickly at this work, it seems similar to the results I got.  But
> there's a lot of code there that came from somewhere?

>From me? ... except the kernel-doc script which is a fork from your 

  git://git.lwn.net/linux.git doc/sphinx


>  I'd put together a
> fairly simple conversion using pandoc and a couple of short sed scripts;
> is there a reason for a more complex solution?

It depends. If you have a simple DocBook with less various markup, maybe not.
May you want to read my remarks about migration tools and especially pandoc:

* https://return42.github.io/sphkerneldoc/articles/dbtools.html#remarks-on-pandoc

A few more words about, what I have done:

I wrote a lib of XML filters which might be also usefully in other
migration projects (dbxml). 

* https://github.com/return42/sphkerneldoc/blob/master/scripts/dbxml.py

It uses a xml-parser, pandoc, pandoc-filters and regular expressions. Because
I did not implemented a whole converter, I hacked around pandoc. Thats why
conversion is done in several steps:

1. copy xml file(s) to a cache space

2. substitude unsolved internal and external entities

3. filter all xml files

   * run custom hooks on every node 

   * apply filters on every node and inject reST into the XML-tree where pandoc fails.
     https://github.com/return42/sphkerneldoc/blob/master/scripts/dbxml.py#L515

4. convert intermediary XML result with pandoc to json (needed by pandoc filters)

5. apply pandoc-filter and clean up the injected reST markup from step3

6. convert filtered json to reST

7. fix the produce reST with regular expression

... the last step is similar to your sed scripts.


And I wrote a commandline Interface to use this lib (see func db2rst):

* https://github.com/return42/sphkerneldoc/blob/master/scripts/dbtools.py#L146
 
With this db2rst all kernel DB-XML books could be migrated, except the linux-tv
book, which has much more complexity. For this, there is a separated commandline
called media2rst

* https://github.com/return42/sphkerneldoc/blob/master/scripts/dbtools.py#L107

The media2rst needs several special handlings, which is implemented in 
hooks (the dbxml interface method)

* https://github.com/return42/sphkerneldoc/blob/master/scripts/media.py

Summarize, why should one prefer this tools over pandoc + sed?

* Pandoc coverage is less on reading and writing, this is where 
  dbxml comes into play

  - reading DocBook: 
    https://github.com/jgm/pandoc/blob/master/src/Text/Pandoc/Readers/DocBook.hs#L23
  
  - writing reST has many bugs and leaks 
    (you fixed some of them with sed)

* Pandoc does not support external entities (linux-tv), covered by dbxml

* dbxml brings the ability to chunk one large XML book into small 
  reST chunks e.g. kernel-hacking book:

    https://github.com/return42/sphkerneldoc/tree/master/doc/books/kernel-hacking

* dbxml lets you manipulate the XML source before you convert it to reST

  this might helpfull e.g. if you have to convert single-column informal-tables 
  to lists or other things ... in short; dbxml and it's hooks are the key to hack
  everything you need in a full automated DocBook-->reST migration workflow.


--Markus--

> Thanks for looking into this, anyway; I hope to be able to focus more on
> it shortly.
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

