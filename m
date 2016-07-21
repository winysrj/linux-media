Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:55356 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbcGUOmJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 10:42:09 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160720172858.6659275d@lwn.net>
Date: Thu, 21 Jul 2016 16:41:53 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <A1987523-8798-4744-81B3-8DA678651634@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com> <578DF08F.8080701@xs4all.nl> <20160719081259.482a8c04@recife.lan> <6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de> <20160719115319.316349a7@recife.lan> <20160719164916.3ebb1c74@lwn.net> <20160719210023.2f8280ac@recife.lan> <E8A50DCE-D40B-4C4C-B899-E48F3C0C9CDA@darmarit.de> <20160720172858.6659275d@lwn.net>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 21.07.2016 um 01:28 schrieb Jonathan Corbet <corbet@lwn.net>:

> On Wed, 20 Jul 2016 08:07:54 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
>> Jon, what do you think ... could we serve this 1.2 doc 
>> on https://www.kernel.org/doc/ as reference?
> 
> Seems like a good idea.  I don't really know who controls that directory,
> though; I can ping Konstantin and see what can be done there.  Failing
> that, I'd be more than happy to put it up on lwn, of course.
> 
>> And whats about those who have 1.3 (or any version >1.2) as default 
>> in the linux distro? Should they install a virtualenv?  ... it is
>> a dilemma.
> 
> I would hope that most people wouldn't have to worry about it, and would
> be able to just use what their distribution provides - that's the reason
> for the 1.2 compatibility requirement in the first place.

Yes, but this is not what I mean ;) ... if someone use a distro 
with a version > 1.2 and he use features not in 1.2, you -- the
maintainer -- will get into trouble. 

IMHO contributors need a reference documentation (e.g. at kernel.org)
and a reference build environment (like you, see below).

> I'll make a
> point of having a 1.2 installation around that I can test things with;
> that should suffice to catch any problems that sneak in.

This is what I called the reference build environment. IMHO a 
ref build env could only be assert by a virtualenv instance.

Here is what I tried to get one  ....

first: create instance:

 $ virtualenv /share/sph12env

second: source the virtualenv

 $ source /share/sph12env/bin/activate
 $ which pip
 /share/sph12env/bin/pip

third: install Sphinx 1.2

$ pip install Sphinx==1.2
$ sphinx-build --version
Sphinx (sphinx-build) 1.2

seems fine ... now install rtd theme :-o

$ pip install sphinx_rtd_theme==0.1.8
Collecting sphinx_rtd_theme==0.1.8
 Downloading sphinx_rtd_theme-0.1.8-py2.py3-none-any.whl (418kB)
Collecting sphinx>=1.3 (from sphinx_rtd_theme==0.1.8)
...

since sphinx>=1.3 is a requirement [1] of the sphinx_rtd_theme package
sphinx has been updated:

$ sphinx-build --version
Sphinx (sphinx-build) 1.4.5

Aaargh ... at the least now, I have strong doubts if it is a clever
decision to use an old sphinx version as reference.

Lets lean back and remember why we need this ... whatever
sphinx version a distro ships (with it's next update) you need a
reference environment ... version 1.2 or the latest version ... equal 
if you are a maintainer or a contributor ...  

So why not installing a updated version in a virtualenv on the build
server, may be in a jail. If contributors have installed older versions,
this is not a problem, the updated one is downward compatible.

[1] https://github.com/snide/sphinx_rtd_theme/blob/0.1.8/requirements.txt

-- Markus --








