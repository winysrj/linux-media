Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:52135 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbcEFLXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2016 07:23:25 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <87inytn6n2.fsf@intel.com>
Date: Fri, 6 May 2016 13:23:06 +0200
Cc: Daniel Vetter <daniel@ffwll.ch>, Jonathan Corbet <corbet@lwn.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Grant Likely <grant.likely@secretlab.ca>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media\@vger.kernel.org linux-media"
	<linux-media@vger.kernel.org>,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6BDB8BFB-6AEA-46A8-B535-C69FBC6FF3BD@darmarit.de>
References: <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan> <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de> <8992F589-5B66-4BDB-807A-79AC8644F006@darmarit.de> <20160412094620.4fbf05c0@lwn.net> <CACxGe6ueYTEZjmVwV2P1JQea8b9Un5jLca6+MdUkAHOs2+jiMA@mail.gmail.com> <CAKMK7uFPSaH7swp4F+=KhMupFa_6SSPoHMTA4tc8J7Ng1HzABQ@mail.gmail.com> <54CDCFE8-45C3-41F6-9497-E02DB4184048@darmarit.de> <874maef8km.fsf@intel.com> <13D877B1-B9A2-412A-BA43-C6A5B881A536@darmarit.de> <20160504134346.GY14148@phenom.ffwll.local> <44110C0C-2E98-4470-9DB1-B72406E901A0@darmarit.de> <87inytn6n2.fsf@intel.com>
To: Jani Nikula <jani.nikula@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hy Jani,

Am 04.05.2016 um 18:13 schrieb Jani Nikula <jani.nikula@intel.com>:

>> Am 04.05.2016 um 17:09 schrieb Jonathan Corbet <corbet@lwn.net>:
>> 
>>> I think all of this makes sense.  It would be really nice to have the
>>> directives in the native sphinx language like that.  I *don't* think we
>>> need to aim for that at the outset; the docproc approach works until we can
>>> properly get rid of it.  What would be *really* nice would be to get
>>> support for the kernel-doc directive into the sphinx upstream.
>> 
>> No need for kernel-doc directive in sphinx upstream, later it will be 
>> an extension which could be installed by a simple command like 
>> "pip install kernel-doc-extensions" or similar.
>> 
>> I develop these required extension (and more) within my proof of concept
>> on github ... this takes time ... if I finished all my tests and all is
>> well, I will build the *kernel-doc-extensions* package and deploy it
>> on https://pypi.python.org/pypi from where everyone could install this 
>> with "pip".
> 
> I think we should go for vanilla sphinx at first, to make the setup step
> as easy as possible for everyone. Even if it means still doing that ugly
> docproc step to call kernel-doc. We can improve from there, and I
> definitely appreciate your work on making this work with sphinx
> extensions.

+1 

> That said, how would it work to include the kernel-doc extension in the
> kernel source tree? Having things just work if sphinx is installed is
> preferred over requiring installation of something extra from pypi. (I
> know this may sound backwards for a lot of projects, but for kernel I'm
> pretty sure this is how it should be done.)

Thats all right. Lets talk about the extension infrastructure by example:

First we have to chose a folder where we place all the *sphinx-documentation*
I recommending:

 /share/linux/Documentation/sphinx

Next we have to chose a folder where reST-extensions should take place, I
would prefer ... or similar:
 
 /share/linux/Documentation/sphinx/extensions

Lets say, you wan't to get in use of the "flat-table" extension.

Copy (only) the rstFlatTable.py file from my POC extension folder (ignore
other extensions which might be there) ...

 https://github.com/return42/sphkerneldoc/tree/master/doc/extensions

Now lets say you are writing on a gpu book, it wold be placed in the folder:

 /share/linux/Documentation/sphinx/gpu

In this gpu-folder you have to place the conf.py config file, needed to
setup the sphinx build environment.

 /share/linux/Documentation/sphinx/gpu/conf.py

In this conf.py you have to *register* your folder with the extensions.

<SNIP conf.py> --------

    import os.path, sys

    EXT_PATH  = "../extensions"  # the path of extension folder relative to the conf.py file
    sys.path.insert(0, os.path.join(os.path.dirname(__file__), EXT_PATH)))

    # now import the "flat-table" extension, it will be self-registering to docutils

    import rstFlatTable

<SNIP conf.py> --------

Thats all, you can run your sphinx-build command and the flat-tables in your
reST sources should be handled as common tables.

ASIDE: 

You will find similar parts in your conf.py which you have created 
with the sphinx-quickstart command. There, you will also find a block 
looks like ...

extensions = [
    'sphinx.ext.autodoc'
....
]

Don't try to add flat-table extension to this list. This list is a list
of sphinx extensions, we will use it later for other *real* sphinx 
extensions.

A few words about the flat-table extension and a (future) kernel-doc one:

The flat-table is a pure docutils (the layer below sphinx) extension which
is not application specific, so I will ask for moving it to the docutils 
upstream. 

The kernel-doc extension on the other side is a very (very) kernel specific
application, this would never go to sphinx nor docutils upstream.

--Markus--

